// Serves /pathofnur/main.dart.js from its pre-compressed copies (see
// wrangler.jsonc). Every other path is a static asset and never reaches here.
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const accepts = request.headers.get('Accept-Encoding') ?? '';
    const encoding = /\bbr\b/.test(accepts) ? 'br' : 'gzip';
    url.pathname += encoding === 'br' ? '.br' : '.gz';

    const asset = await env.ASSETS.fetch(new Request(url, request));
    if (asset.status !== 200 && asset.status !== 304) return asset;

    const headers = new Headers(asset.headers);
    headers.set('Content-Type', 'text/javascript; charset=utf-8');
    headers.set('Vary', 'Accept-Encoding');
    headers.set('X-Robots-Tag', 'noindex');
    if (asset.status === 200) headers.set('Content-Encoding', encoding);
    return new Response(asset.body, {
      status: asset.status,
      headers,
      encodeBody: 'manual',
    });
  },
};
