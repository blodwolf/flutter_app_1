import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget{
  const MyContainer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('container study'),
        leading: BackButton(),
      ),
      body: ContainerContent(),
    );
  }
}


class ContainerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Wrap(
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headline1.fontSize * 1.1 + 100.0,
            ),
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.red),
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                    image: ExactAssetImage("images/maomi.jpg"),
                    centerSlice: Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0))),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              'Hello World',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
            transform: Matrix4.rotationZ(0.3),
          ),
          Container(
            margin: const EdgeInsets.only(top: 105.0),
            child: RoundButton(
              title: Text(
                "default button",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              disabled: false,
              onPress: () {
                final snackBar = SnackBar(content: Text('click one'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: RoundButton(
              width: 250.0,
              height: 40.0,
              backgroundColor: Colors.green,
              activeBackgroundColor: Colors.greenAccent,
              disabledBackgroundColor: Colors.lightGreen,
              title: Text(
                'custom button',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              disabled: false,
              onPress: () {
                final snackBar = SnackBar(content: Text('click two'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          RoundButton(
            title: Text(
              'disabled button',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            disabled: false,
            onPress: () {
              final snackBar = SnackBar(content: Text('click three'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          )
        ],
      ),
    );
  }
}

class RoundButton extends StatefulWidget {
  static const defaultBackgroundColor = const Color(0xFF8B5FFE);
  static const defaultActiveBackgroundColor = const Color(0xB38B5FFE);
  static const defaultDisabledBackgroundColor = const Color(0x338B5FFE);

  final Widget title;
  final Color backgroundColor, activeBackgroundColor, disabledBackgroundColor;
  final VoidCallback onPress;
  final double height, width;
  final bool disabled;

  RoundButton({
    this.title,
    this.onPress,
    this.height=40.0,
    this.width,
    this.disabled,
    this.backgroundColor = defaultBackgroundColor,
    this.activeBackgroundColor = defaultActiveBackgroundColor,
    this.disabledBackgroundColor = defaultDisabledBackgroundColor,
  });

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  Color currentColor;

  @override
  void initState() {
    super.initState();
    if (widget.disabled) {
      currentColor = widget.disabledBackgroundColor;
    } else {
      currentColor = widget.backgroundColor;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    currentColor = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    //GestureDetector 手势监听
    return GestureDetector(
      onTap: () {
        //点击事件
        if (widget.onPress != null && !widget.disabled) {
          widget.onPress();
        }
      },
      onTapDown: (TapDownDetails details) {
        //像键盘一下 按下事件
        if (!widget.disabled) {
          setState(() {
            currentColor = widget.activeBackgroundColor;
          });
        }
      },
      onTapUp: (TapUpDetails details) {
        //跟上面一样 键盘弹起事件
        if (!widget.disabled) {
          setState(() {
            currentColor = widget.backgroundColor;
          });
        }
      },
      onTapCancel: () {
        //点击事件取消
        if (!widget.disabled) {
          setState(() {
            currentColor = widget.backgroundColor;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.height/2.0))),
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        child: widget.title,
      ),
    );
  }
}
