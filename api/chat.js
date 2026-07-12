// EF Adults Sales Simulator — chat proxy
const Anthropic = require('@anthropic-ai/sdk');

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  if (!process.env.ANTHROPIC_API_KEY) {
    return res.status(500).json({
      error: 'ANTHROPIC_API_KEY is not configured on the server.'
    });
  }

  try {
    const {
      messages,
      systemPrompt,
      model = 'claude-haiku-4-5-20251001',
      maxTokens = 500,
    } = req.body;

    if (!messages || !systemPrompt) {
      return res.status(400).json({ error: 'messages and systemPrompt are required' });
    }

    const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

    const response = await client.messages.create({
      model,
      max_tokens: maxTokens,
      system: systemPrompt,
      messages,
    });

    return res.status(200).json({ content: response.content[0].text });
  } catch (err) {
    console.error('Chat API error:', err);
    return res.status(500).json({ error: err.message || 'Unknown error' });
  }
};
