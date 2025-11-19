import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final List<String> _acceptedEmailDomains = ['@gmail.com', '@uisi.ac.id', '@example.com'];

  void _register() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${_nameController.text}');
      print('Nik: ${_nikController.text}');
      print('Email: ${_emailController.text}');
      print('Phone Number: ${_phoneController.text}');
      print('Address: ${_addressController.text}');
      print('Username: ${_usernameController.text}');
      print('Password: ${_passwordController.text}');

      Navigator.pushReplacementNamed(context, '/'); 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        leading: Icon(
           Icons.arrow_back,
        ),
        title: Text('Registrasi Akun'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Text(
                'Selamat datang di halaman pendaftaran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Silahkan mengisi form pendaftaran di bawah ini',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 20),
              

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        hintText: 'Masukkan nama',
                        prefixIcon: Icon(Icons.person_outline),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Nik Field
                    TextFormField(
                      controller: _nikController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan NIK',
                        hintText: 'Contoh: 1234567890123456',
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Example: 08123456789',
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        // Example: Check for a minimum length, e.g., 10 digits
                        if (value.length < 10) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Address Field
                    TextFormField(
                      controller: _nikController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Alamat',
                        hintText: 'Misal: Jakarta, Indonesia',
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Masukkan Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        // Basic email format validation
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Format email tidak valid';
                        }
                        // Check for the specific domain ending
                        if (!_acceptedEmailDomains.any((domain) => value.endsWith(domain))) {
                          return 'Hanya domain ${_acceptedEmailDomains.join(', ')} yang bisa diterima';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        hintText: 'Masukkan kata sandi',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Your password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Register Button
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C824A),
                        padding: const EdgeInsets.symmetric(horizontal: 120.0),
                        minimumSize: const Size.fromHeight(48), // Make button at least 48 high
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah memiliki akun? '),
                        TextButton( 
                          onPressed: () {
                            
                          },
                          child: Text(
                            'Login disini!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}