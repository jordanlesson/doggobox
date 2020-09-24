import 'package:doggobox/index.dart';

class InfoTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String) onChanged;
  final Iterable<String> autofillHints;

  InfoTextField({
    @required this.label,
    @required this.hintText,
    this.onChanged,
    this.keyboardType,
    this.autofillHints,
  });

  @override
  _InfoTextFieldState createState() => _InfoTextFieldState();
}

class _InfoTextFieldState extends State<InfoTextField> {
  Widget _buildTextFieldLabel() {
    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
        bottom: 15.0,
      ),
      alignment: Alignment.topLeft,
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      // height: 60.0,
      // color: Colors.red,
      //margin: EdgeInsets.symmetric(vertical: 15.0),
      alignment: Alignment.topLeft,
      child: TextField(
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        //focusNode: emailFocusNode,
        textCapitalization: TextCapitalization.words,
        keyboardType: widget.keyboardType != null
            ? widget.keyboardType
            : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(1.0),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(1.0),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(1.0),
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.all(20.0),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        // onChanged: (String input) {
        //   emailBloc.checkEmail(input);
        // },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildTextFieldLabel(),
          _buildTextField(),
        ],
      ),
    );
  }
}
