'use client';
import { useState } from 'react';
import { api } from '@/lib/api';
import { Send } from 'lucide-react';

export default function TutorPage() {
  const [messages, setMessages] = useState<{ role: string; text: string }[]>([]);
  const [input, setInput] = useState('');
  const [sending, setSending] = useState(false);

  async function send() {
    if (!input.trim() || sending) return;
    const msg = input.trim();
    setMessages(m => [...m, { role: 'user', text: msg }]);
    setInput('');
    setSending(true);
    try {
      const res = await api.tutorChat(msg);
      setMessages(m => [...m, { role: 'assistant', text: res.response || res.strategy || 'OK' }]);
    } catch (e: any) {
      setMessages(m => [...m, { role: 'assistant', text: `Error: ${e.message}` }]);
    }
    setSending(false);
  }

  return (
    <div className="flex flex-col h-full">
      <h2 className="text-2xl font-bold mb-4">AI Tutor</h2>
      <div className="flex-1 bg-white rounded-xl p-4 shadow-sm border border-gray-100 overflow-auto mb-4 space-y-3">
        {messages.length === 0 && (
          <p className="text-gray-400 text-sm text-center mt-8">
            Start a conversation with your AI tutor. Try: &ldquo;Jelaskan conditional sentences&rdquo;
          </p>
        )}
        {messages.map((m, i) => (
          <div key={i} className={`p-3 rounded-lg max-w-[80%] text-sm ${
            m.role === 'user' ? 'bg-brand-100 ml-auto' : 'bg-gray-100'
          }`}>
            {m.text}
          </div>
        ))}
      </div>
      <div className="flex gap-2">
        <input
          className="flex-1 border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-300"
          placeholder="Ask your tutor..."
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && send()}
        />
        <button onClick={send} disabled={sending}
          className="bg-brand-600 text-white px-4 py-2 rounded-lg hover:bg-brand-700 disabled:opacity-50">
          <Send size={18} />
        </button>
      </div>
    </div>
  );
}