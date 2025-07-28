import 'package:flutter/material.dart';
import 'home_page.dart';
import 'message_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final TextEditingController _userC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void changePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void clearText() {
    _userC.clear();
    _passwordC.clear();
  }

  void validateAndSubmit(BuildContext context){
    if (_userC.text.isEmpty || _passwordC.text.isEmpty) {
      MessagePage.showMessage(context, '請輸入使用者名稱和密碼');
    } else {
      setState(() {
        _isLoading = true;
      });
      // 模擬登入過程
      final navigator = Navigator.of(context);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        navigator.push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      });
      clearText();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF1F2937),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo 或圖標
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 40,
                color: Colors.indigo.shade300,
              ),
            ),
            const SizedBox(height: 24),
            
            // 標題
            Text(
              '歡迎回來',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '請登入您的帳戶',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 32),
            
            // 使用者名稱輸入框
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: TextField(
                controller: _userC,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '使用者名稱',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 密碼輸入框
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: TextField(
                controller: _passwordC,
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '密碼',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 登入按鈕
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => validateAndSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        '登入',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                MessagePage.showMessage(context, '忘記密碼功能尚未實作');
              },
              child: Text(
                '忘記密碼？',
                style: TextStyle(
                  color: Colors.indigo.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}