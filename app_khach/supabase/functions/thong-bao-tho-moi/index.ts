import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { JWT } from 'https://esm.sh/google-auth-library@9'

const firebaseProjectId = 'vieclam24h-da70e';

serve(async (req) => {
  try {
    const payload = await req.json();
    const donHangMoi = payload.record;

    // Chỉ xử lý khi có đơn hàng mới (INSERT)
    if (payload.type !== 'INSERT') {
      return new Response('Bỏ qua vì không phải đơn hàng mới', { status: 200 });
    }

    // Khởi tạo Supabase Admin
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Lấy danh sách fcm_token của tất cả Thợ (Bảng tho)
    const { data: danhSachTho, error: loiTruyVan } = await supabase
      .from('tho')
      .select('fcm_token')
      .not('fcm_token', 'is', null);

    if (loiTruyVan || !danhSachTho || danhSachTho.length === 0) {
      return new Response('Không có thợ nào để gửi thông báo', { status: 200 });
    }

    // Cấu hình nội dung thông báo dựa trên tính năng khác biệt (SOS)
    const tieuDe = donHangMoi.sos ? '🚨 ĐƠN CẤP CỨU SOS!' : '🛠️ Có đơn gọi thợ mới!';
    const noiDung = `Dịch vụ: ${donHangMoi.loaiDichVu}. Địa chỉ: ${donHangMoi.dia_chi}`;

    // Lấy Access Token từ biến môi trường đã nạp qua .env.local
    const clientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL') ?? '';
    const privateKey = Deno.env.get('FIREBASE_PRIVATE_KEY')?.replace(/\\n/g, '\n') ?? '';

    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    });
    const tokens = await jwtClient.getAccessToken();
    const accessToken = tokens.token;

    // Gửi thông báo đến từng thợ
    const cacYeuCauGui = danhSachTho.map(async (tho) => {
      const fcmUrl = `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`;
      return fetch(fcmUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: tho.fcm_token,
            notification: { title: tieuDe, body: noiDung },
            data: { donHangId: donHangMoi.id.toString() }
          }
        }),
      });
    });

    await Promise.all(cacYeuCauGui);

    return new Response(JSON.stringify({ ketQua: "Đã gửi thông báo cho thợ" }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});