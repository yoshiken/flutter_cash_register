import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter cash register',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> _cartProducts = [];

  void _allRemoveCart() {
    setState(() {
      _cartProducts = [];
    });
  }

  void _addCart(Map product) {
    setState(() {
      _cartProducts.add(product);
    });
  }

  void _removeCart(Map product) {
    setState(() {
      _cartProducts.remove(product);
    });
  }

  int getAllCartPrice() {
    int totalPrice = 0;
    int tmp = 0;
    if (_cartProducts.isEmpty) return totalPrice;
    for (int i = 0; i < _cartProducts.length; i++) {
      tmp = _cartProducts[i]["price"];
      totalPrice += tmp;
    }
    return totalPrice;
  }

  List productList = [
    {
      "name": "example1",
      "price": 100,
    },
    {
      "name": "example2",
      "price": 200,
    },
    {
      "name": "example3",
      "price": 300,
    },
    {
      "name": "example4",
      "price": 400,
    },
    {
      "name": "example5",
      "price": 500,
    },
    {
      "name": "example6",
      "price": 600,
    },
    {
      "name": "example7",
      "price": 700,
    },
    {
      "name": "example8",
      "price": 800,
    },
    {
      "name": "example9",
      "price": 900,
    },
    {
      "name": "example10",
      "price": 1000,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _productList(productList, context),
            _price(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NextPage()));
        },
        tooltip: 'お会計',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _productList(List productList, BuildContext context) {
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.height * 0.65,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  _addCart(productList[index]);
                });
              },
              child: Card(
                child: ListTile(
                  title: Text(productList[index]["name"]),
                  subtitle: Text(productList[index]["price"].toString()),
                ),
              ));
        },
      ),
    );
  }

  Widget _price(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.red,
      child: Row(
        children: [
          _selectedProduct(context),
          _totalPrice(context),
        ],
      ),
    );
  }

  Widget _selectedProduct(BuildContext context) {
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.width,
      child: _selectedProductList(context),
    );
  }

  Widget _selectedProductList(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.green,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  _removeCart(_cartProducts[index]);
                });
              },
              child: Card(
                child: ListTile(
                  title: Text(_cartProducts[index]["name"]),
                  subtitle: Text(_cartProducts[index]["price"].toString()),
                ),
              ));
        },
      ),
    );
  }

  Widget _totalPrice(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.yellow,
      child: Column(
        children: [
          const Text("Total Price"),
          Text(getAllCartPrice().toString(),
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 64)),
        ],
      ),
    );
  }
}
