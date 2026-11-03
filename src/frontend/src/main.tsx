import { StrictMode, useEffect, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { checkLiveness } from './health';
import './style.css';

function App() {
  const [status, setStatus] = useState('확인 중');
  const [attempt, setAttempt] = useState(0);
  useEffect(() => {
    const controller = new AbortController();
    setStatus('확인 중');
    void checkLiveness(AbortSignal.any([controller.signal, AbortSignal.timeout(5000)]))
      .then(() => { if (!controller.signal.aborted) setStatus('연결됨'); })
      .catch(() => { if (!controller.signal.aborted) setStatus('연결 확인 필요'); });
    return () => controller.abort();
  }, [attempt]);

  return (
    <main>
      <header><strong>RICP</strong><span>매장 IT 자산 포털</span></header>
      <section aria-labelledby="title">
        <p className="eyebrow">프로젝트 초기 구성</p>
        <h1 id="title">매장과 자산을 한곳에서</h1>
        <p>현재는 서비스 연결을 확인하는 준비 화면입니다.</p>
        <dl>
          <div><dt>API 서비스</dt><dd role="status">{status}</dd></div>
          <div><dt>회사 계정 로그인</dt><dd>연동 준비 중</dd></div>
          <div><dt>자산 데이터</dt><dd>연결 전</dd></div>
        </dl>
        <button type="button" onClick={() => setAttempt(value => value + 1)}>연결 다시 확인</button>
        <p className="note">실제 매장·자산 데이터는 아직 조회하지 않습니다.</p>
      </section>
    </main>
  );
}

createRoot(document.getElementById('root')!).render(<StrictMode><App /></StrictMode>);
