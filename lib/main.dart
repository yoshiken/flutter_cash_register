import 'package:flutter/material.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';

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

  Map<String, List<Map<String, dynamic>>> productListMap = {
    "product": [
      {"name": "example1", "price": 100},
      {"name": "example2", "price": 200},
      {"name": "example3", "price": 300},
      {"name": "example4", "price": 400},
      {"name": "example5", "price": 500},
      {"name": "example6", "price": 600},
      {"name": "example7", "price": 700},
      {"name": "example8", "price": 800},
      {"name": "example9", "price": 900},
      {"name": "example10", "price": 1000},
      {"name": "example11", "price": 0},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _productList(productListMap, context),
            _price(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NextPage(getAllCartPrice().toString())));
        },
        tooltip: 'お会計',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _productList(Map<String, List<Map<String, dynamic>>> productMap,
      BuildContext context) {
    List<Map<String, dynamic>>? tmp = productMap["product"];
    if (tmp == null) {
      return const Text("No Data");
    }
    List<Map<String, dynamic>> productList = tmp;
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

class NextPage extends StatefulWidget {
  final String price;

  const NextPage(this.price, {super.key});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late int price = int.parse(widget.price);
  var inputNumber = "";
  var str = "";
  var change = 0;

  int depositAmount = 0;

  void _onKeyboardTap(String value) {
    setState(() {
      str = depositAmount.toString() + value;
      depositAmount = int.parse(str);
      change = depositAmount - price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('計算ページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("合計金額: $price",
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),
            Text("お預かり金額: $depositAmount",
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),
            Text("おつり: $change",
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),
            NumericKeyboard(
              onKeyboardTap: _onKeyboardTap,
              rightButtonFn: () {
                if (depositAmount == 0) return;
                if (depositAmount.toString().length == 1) {
                  setState(() {
                    depositAmount = 0;
                    change = depositAmount - price;
                  });
                  return;
                }
                setState(() {
                  str = depositAmount.toString();
                  depositAmount =
                      int.parse(str.toString().substring(0, str.length - 1));
                  change = depositAmount - price;
                });
              },
              rightIcon: const Icon(
                Icons.backspace,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
              child: const Text("購入！"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
