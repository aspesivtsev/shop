import 'package:flutter/material.dart';
import '../providers/product.dart';

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
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

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
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState!.save();
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
          key: _form,

          ///подключение данной формы к глобальному ключу
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                autofocus: true,
                onFieldSubmitted: (_) {
                  ///при завершении редактирования и нажатии кнопки Далее/Next
                  ///передать фокус на указатель _priceFocusNode
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,

                ///клава с десятичными числами
                ///keyboardType: TextInputType.numberWithOptions(decimal: true),
                keyboardType: TextInputType.number,

                ///показывает что это то поле, на которое нужно переводить фокус
                ///при обращении к _priceFocusNode
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  ///при завершении редактирования и нажатии кнопки Далее/Next
                  ///передать фокус на указатель _descriptionFocusNode
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
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
