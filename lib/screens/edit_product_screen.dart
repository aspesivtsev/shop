import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ///указатель на фокус для поля Price и Description
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  var _editedProduct = Product(
      id: 'newProduct', title: '', description: '', price: 0, imageUrl: '');

  //это значения для новой записи с пустыми значениями
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;

  ///глобальный ключ для работы с формой
  final _form = GlobalKey<FormState>();

  //контроллер рисунка в форме
  final _imageUrlController = TextEditingController();

  ///тут мы добавляем listener который будет слушать изменения фокуса в Image URL
  ///и если изменения наступили он будет запускать определенную функцию
  ///в данном случае _updateImageUrl
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;

      if (productId != 'newProduct') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '', //задаем ниже через контроллер
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //метод dispose вызывавем в ручную чтобы они не засоряли память
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  ///тут мы вызываем апдейт интерфейса чтобы прорисовать загруженную картинку
  ///в превью в моменте перевода фокуса
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      /// тут мы проверяем ряд условий для того, чтобы не отображать превью картинки, если адрес картинки не верный
      if ((_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https')) ||
          (_imageUrlController.text.endsWith('.png') &&
              _imageUrlController.text.endsWith('.jpg') &&
              _imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    ///запуск механизма валидации на форме. Если какой-то валидатор провалится, то в isValid попадет false
    final isValid = _form.currentState!.validate();

    ///если isValid не равняется true, то мы не сохраняем результат формы
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if (_editedProduct.id != 'newProduct') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();

    print(_editedProduct.id);
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          ///подключение данной формы к глобальному ключу
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                autofocus: true,

                ///при завершении редактирования и нажатии кнопки Далее/Next
                ///передать фокус на указатель _priceFocusNode
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },

                ///событие происходящее при сохранении формы.
                ///value содержит значение, которое вводилось в поле формы
                ///остальные поля остаются без изменения и берутся из объекта
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: value!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },

                ///в value попадает значение user input
                ///return null значит ввод корректный
                ///return 'Error message' значит вернуть ошибку с указанным текстом
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,

                ///клава с десятичными числами
                keyboardType: TextInputType.numberWithOptions(decimal: true),

                ///keyboardType: TextInputType.number,

                ///показывает что это то поле, на которое нужно переводить фокус
                ///при обращении к _priceFocusNode
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  ///при завершении редактирования и нажатии кнопки Далее/Next
                  ///передать фокус на указатель _descriptionFocusNode
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price cannot be 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a description';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey)),
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Enter URL'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue: _initValues['imageUrl'], //инитвалью и контроллер не могут использоваться одновременно
                      //поэтому если есть контроллер то нужно через него устанавливать значение, тут мы это делаем в didChangeDependencies()
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,

                      ///при нажатии на кнопку done на софтварной клавиатуре
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },

                      ///перерисовываем UI
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide an image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter valid URL for a picture file';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
