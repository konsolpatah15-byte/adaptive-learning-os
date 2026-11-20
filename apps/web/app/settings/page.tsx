'use client';
import { useState } from 'react';
import { api, setToken } from '@/lib/api';

export default function SettingsPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [status, setStatus] = useState('');
  const [token, setTokenState] = useState('');

  async function handleLogin() {
    setStatus('Logging in...');
    try {
      const res = await api.login(username, password);
      setToken(res.token);
      setTokenState(res.token);
      setStatus(`Logged in as ${res.display_name}`);
      localStorage.setItem('alos_token', res.token);
    } catch (e: any) {
      setStatus(`Login failed: ${e.message}`);
    }
  }

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Settings</h2>

      <div className="max-w-md space-y-6">
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <h3 className="font-semibold mb-4">Login</h3>
          <div className="space-y-3">
            <input
              className="w-full border border-gray-200 rounded-lg px-4 py-2 text-sm"
              placeholder="Username"
              value={username}
              onChange={e => setUsername(e.target.value)}
            />
            <input
              className="w-full border border-gray-200 rounded-lg px-4 py-2 text-sm"
              type="password"
              placeholder="Password"
              value={password}
              onChange={e => setPassword(e.target.value)}
            />
            <button
              onClick={handleLogin}
              className="w-full bg-brand-600 text-white py-2 rounded-lg text-sm hover:bg-brand-700"
            >
              Login
            </button>
            {status && <p className="text-xs text-gray-500 mt-2">{status}</p>}
            {token && <p className="text-xs text-gray-400 mt-1 truncate">Token: {token.slice(0, 20)}...</p>}
          </div>
        </div>

        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <h3 className="font-semibold mb-3">Preferences</h3>
          <div className="space-y-3 text-sm text-gray-600">
            <div className="flex justify-between">
              <span>Weekday study time</span>
              <span>90 min (16:30-19:00)</span>
            </div>
            <div className="flex justify-between">
              <span>Weekend study time</span>
              <span>3.5 hours</span>
            </div>
            <div className="flex justify-between">
              <span>Explanation language</span>
              <span>Indonesian</span>
            </div>
            <div className="flex justify-between">
              <span>Teach before test</span>
              <span className="text-green-600">Enabled</span>
            </div>
            <div className="flex justify-between">
              <span>API endpoint</span>
              <span className="font-mono text-xs">127.0.0.1:8000</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}