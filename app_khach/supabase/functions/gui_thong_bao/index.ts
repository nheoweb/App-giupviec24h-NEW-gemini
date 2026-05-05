import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (yeuCau) => {
  try {
    // 1. Lấy dữ liệu từ Database Webhook khi có đơn hàng mới
    const payload = await yeuCau.json()
    const donHangMoi = payload.record 

    // 2. Kết nối vào DB bằng quyền Admin để lấy fcmToken của Thợ
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    const supabase = createClient(supabaseUrl, supabaseKey)

    // Truy vấn cột fcmToken từ bảng nguoiDung dựa vào idTho
    const { data: duLieuTho, error: loiTruyVan } = await supabase
      .from('nguoiDung')
      .select('fcmToken')
      .eq('id', donHangMoi.idTho)
      .single()

    if (loiTruyVan || !duLieuTho?.fcmToken) {
      return new Response(JSON.stringify({ loi: 'Không tìm thấy Token thiết bị của thợ này' }), { status: 400 })
    }

    // 3. Cấu hình gói tin Push Notification bắn qua Firebase (FCM)
    // Lưu ý: Cần có Service Account Key của Firebase để xác thực API HTTP v1
    const accessToken = Deno.env.get('FIREBASE_ACCESS_TOKEN') ?? ''
    const projectId = 'vieclam24h-da70e' // Sẽ thay bằng ID thực tế của anh

    const tinNhanPush = {
      message: {
        token: duLieuTho.fcmToken,
        notification: {
          title: "Ting ting! Có đơn gọi thợ mới",
          body: "Khách hàng vừa đặt lịch dịch vụ. Mở app để xem chi tiết ngay!",
        },
        data: {
          donHangId: donHangMoi.id,
          loaiThongBao: "donHangMoi"
        }
      }
    }

    // 4. Gửi yêu cầu sang máy chủ Firebase
    const ketQuaFirebase = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify(tinNhanPush)
    })

    return new Response(JSON.stringify({ trangThai: "Đã bắn thông báo đẩy thành công!" }), {
      headers: { "Content-Type": "application/json" },
      status: 200
    })

  } catch (loi: any) {
    return new Response(JSON.stringify({ loi: loi.message }), { status: 500 })
  }
})