import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'message_service.dart';
class SettingPage extends StatelessWidget{
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF1F2937),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F2937),
              Color(0xFF111827),
            ],
          ),
        ),
        child: buildSettingList(context),
      ),
    );
  }
}

Widget buildSettingList(BuildContext context) {
  return ListView(
    children: [
      buildSettingCard(
        '帳號設定',
        Icons.account_circle,
        context,
      ),
      buildSettingCard(
        '關於程式',
        Icons.info,
        context,
      ),
    ],
  );
}

Widget buildSettingCard(String title, IconData icon, BuildContext context) {
  return Card(
    margin: const EdgeInsets.all(10),
    color: const Color(0xFF374151),
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Colors.white70,
      ),
      child: ExpansionTile(
        leading: Icon(icon, size: 30, color: Colors.white),
        title: Text(title, style: const TextStyle(fontSize: 20, color: Colors.white)),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: buildSettingInfo(title, '這是$icon的設定資訊', context),
      ),
    ),
  );
}
List<Widget> buildSettingInfo(String title, String description, BuildContext context) {
  switch (title) {
    case '帳號設定':
      return [
        ListTile(
          title: const Text('使用者名稱', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('設定您的使用者名稱', style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
          onTap: () {
            // 處理使用者名稱設定
          },
        ),
        ListTile(
          title: const Text('密碼變更', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('變更您的登入密碼', style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
          onTap: () {
            // 處理密碼變更
          },
        ),
        ListTile(
          title: const Text('個人資料', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('編輯個人資料信息', style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
          onTap: () {
            // 處理個人資料編輯
          },
        ),
      ];
    case '關於程式':
      return [
        ListTile(
          title: const Text('版本資訊', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('v1.0.0', style: TextStyle(fontSize: 14, color: Colors.white70)),
        ),
        ListTile(
          title: const Text('開發者', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('ChenGuoXiang', style: TextStyle(fontSize: 14, color: Colors.white70)),
        ),
        ListTile(
          title: const Text('聯絡我', style: TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: const Text('s1411232069@ad1.nutc.edu.tw', style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.email, color: Colors.white70),
          onTap: () async {
            const url = 'https://github.com/ChenGuoXiang940';
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if(!context.mounted)return;
                    MessagePage.showMessage(context, '無法開啟連結');
                  }
          },
        ),
      ];
    default:
      return [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
          subtitle: Text(description, style: const TextStyle(fontSize: 14, color: Colors.white70))
        ),
      ];
  }
}