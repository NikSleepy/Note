import 'package:flutter/material.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({super.key});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TextField(
                decoration: InputDecoration(labelText: "Kode Produk")),
            const TextField(
                decoration: InputDecoration(labelText: "Nama Produk")),
            const TextField(
                decoration: InputDecoration(labelText: "Harga")),
            ElevatedButton(onPressed: () {}, child: const Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
