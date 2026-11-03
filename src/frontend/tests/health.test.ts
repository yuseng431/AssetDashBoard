import { afterEach, describe, expect, it, vi } from 'vitest';
import { checkLiveness } from '../src/health';

afterEach(() => vi.unstubAllGlobals());

describe('API liveness', () => {
  it('accepts a successful liveness response', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue(Response.json({ status: 'ok' })));
    await expect(checkLiveness()).resolves.toBeUndefined();
  });
  it('rejects an HTTP error even if the body looks successful', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue(Response.json({ status: 'ok' }, { status: 503 })));
    await expect(checkLiveness()).rejects.toThrow('API 연결');
  });
  it.each([null, {}, { status: 'failed' }, 'ok'])('rejects malformed response %j', async body => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue(Response.json(body)));
    await expect(checkLiveness()).rejects.toThrow('응답 형식');
  });
  it('propagates network errors', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('offline')));
    await expect(checkLiveness()).rejects.toThrow('offline');
  });
});
