export async function checkLiveness(signal?: AbortSignal): Promise<void> {
  const response = await fetch('/api/health/live', { signal, cache: 'no-store' });
  if (!response.ok) throw new Error('API 연결을 확인할 수 없습니다.');
  const body: unknown = await response.json();
  if (typeof body !== 'object' || body === null || !('status' in body) || body.status !== 'ok') {
    throw new Error('API 응답 형식이 올바르지 않습니다.');
  }
}
