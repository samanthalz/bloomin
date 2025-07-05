import functions from 'firebase-functions';
import fetch from 'node-fetch';
import { Configuration, OpenAIApi } from 'openai';
import { JSDOM } from 'jsdom';
import { YoutubeTranscript } from 'youtube-transcript';

const openai = new OpenAIApi(
  new Configuration({ apiKey: process.env.OPENAI_API_KEY })
);

export const generateQuizFromSource = functions
  .runWith({ memory: '512MB', timeoutSeconds: 60 })
  .https.onRequest(async (req, res) => {
    try {
      const { type, url, videoId } = req.body;
      let text = '';

      if (type === 'article') {
        const html = await (await fetch(url)).text();
        const dom = new JSDOM(html);
        text =
          dom.window.document.querySelector('article')?.textContent ??
          dom.window.document.body.textContent ??
          '';
      } else if (type === 'video') {
        const t = await YoutubeTranscript.fetchTranscript(videoId);
        text = t.map((p) => p.text).join(' ');
      } else {
        throw new Error('Invalid type');
      }

      if (text.length < 300) {
        throw new Error('Content too short for quiz.');
      }

      const prompt = `
Return EXACT valid JSON (no code fences, no extra keys) in this shape:
{
 "questions":[
   {"question":"...","options":["A","B","C","D"],"correct":1}
 ]
}

Create 3 multiple‑choice questions (4 options each) from the text below:

<<<START_TEXT
${text.slice(0, 3500)}
END_TEXT>>>
`;

      const gpt = await openai.createChatCompletion({
        model: 'gpt-4o-mini',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.3,
      });

      const json = JSON.parse(gpt.data.choices[0].message.content);
      res.status(200).json(json);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: err.message });
    }
  });
