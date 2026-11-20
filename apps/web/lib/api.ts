const API = process.env.NEXT_PUBLIC_API_URL || 'http://127.0.0.1:8000';

let token: string | null = null;

// Auto-load token from localStorage on init (runs once in browser)
if (typeof window !== 'undefined') {
  token = localStorage.getItem('alos_token');
}

export function setToken(t: string) {
  token = t;
  if (typeof window !== 'undefined') {
    localStorage.setItem('alos_token', t);
  }
}

export function clearToken() {
  token = null;
  if (typeof window !== 'undefined') {
    localStorage.removeItem('alos_token');
  }
}

export function getToken() { return token; }
export function isLoggedIn() { return token !== null; }

async function fetchAPI(path: string, opts: RequestInit = {}) {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(opts.headers as Record<string, string> || {}),
  };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(`${API}${path}`, { ...opts, headers });
  if (res.status === 401) {
    clearToken();
  }
  if (!res.ok) {
    const err = await res.json().catch(() => ({ error: res.statusText }));
    throw new Error(err.error || res.statusText);
  }
  return res.json();
}

export const api = {
  login: (username: string, password: string) =>
    fetchAPI('/api/auth/login', { method: 'POST', body: JSON.stringify({ username, password }) }),
  me: () => fetchAPI('/api/auth/me'),
  dashboard: () => fetchAPI('/api/dashboard'),
  dashboardSummary: () => fetchAPI('/api/dashboard/summary'),
  competencies: (track: string) => fetchAPI(`/api/competencies?track=${track}`),
  ieltsProgress: () => fetchAPI('/api/ielts/progress'),
  snbtProgress: () => fetchAPI('/api/snbt/progress'),
  schedule: () => fetchAPI('/api/schedule'),
  mistakes: () => fetchAPI('/api/mistakes'),
  analytics: () => fetchAPI('/api/analytics/progress'),
  weaknesses: () => fetchAPI('/api/analytics/weaknesses'),
  learningRecommendations: () => fetchAPI('/api/learning/recommendations'),
  tutorChat: (message: string, sessionId?: number, track?: string) =>
    fetchAPI('/api/tutor/chat', { method: 'POST', body: JSON.stringify({ message, session_id: sessionId, track }) }),
};