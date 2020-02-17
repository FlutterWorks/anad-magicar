import 'dart:math';

import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'animated_button.dart';
import 'animated_text.dart';
import 'custom_page_transformer.dart';
import 'expandable_container.dart';
import 'fade_in.dart';
import 'animated_text_form_field.dart';
import '../providers/auth.dart';
import '../providers/login_messages.dart';
import '../models/login_data.dart';
import '../dart_helper.dart';
import '../matrix.dart';
import '../paddings.dart';
import '../widget_helper.dart';

class AuthCard extends StatefulWidget {
  AuthCard({
    Key key,
    this.onlyRegister,
    this.padding = const EdgeInsets.all(0),
    this.loadingController,
    this.emailValidator,
    this.mobileValidator,
    this.passwordValidator,
    this.onSubmit,
    this.onSubmitCompleted,
  }) : super(key: key);

  final bool onlyRegister;
  final EdgeInsets padding;
  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> mobileValidator;
  final FormFieldValidator<String> passwordValidator;
  final Function onSubmit;
  final Function onSubmitCompleted;

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  GlobalKey _cardKey = GlobalKey();

  var _isLoadingFirstTime = true;
  var _pageIndex = 0;
  static const cardSizeScaleEnd = .2;

  TransformerPageController _pageController;
  AnimationController _formLoadingController;
  AnimationController _routeTransitionController;
  Animation<double> _flipAnimation;
  Animation<double> _cardSizeAnimation;
  Animation<double> _cardSize2AnimationX;
  Animation<double> _cardSize2AnimationY;
  Animation<double> _cardRotationAnimation;
  Animation<double> _cardOverlayHeightFactorAnimation;
  Animation<double> _cardOverlaySizeAndOpacityAnimation;


  @override
  void initState() {
    super.initState();

    _pageController = TransformerPageController();

    widget.loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isLoadingFirstTime = false;
        _formLoadingController.forward();
      }
    });

    _flipAnimation = Tween<double>(begin: pi / 2, end: 0).animate(
      CurvedAnimation(
        parent: widget.loadingController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    _formLoadingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1150),
      reverseDuration: Duration(milliseconds: 300),
    );

    _routeTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    _cardSizeAnimation = Tween<double>(begin: 1.0, end: cardSizeScaleEnd)
        .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(0, .27272727 /* ~300ms */, curve: Curves.easeInOutCirc),
    ));
    _cardOverlayHeightFactorAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.27272727, .5 /* ~250ms */, curve: Curves.linear),
    ));
    _cardOverlaySizeAndOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.5, .72727272 /* ~250ms */, curve: Curves.linear),
    ));
    _cardSize2AnimationX =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);
    _cardSize2AnimationY =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);
    _cardRotationAnimation =
        Tween<double>(begin: 0, end: pi / 2).animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1 /* ~300ms */, curve: Curves.easeInOutCubic),
    ));
  }

  @override
  void dispose() {
    super.dispose();

    _formLoadingController.dispose();
    _pageController.dispose();
    _routeTransitionController.dispose();
  }

  void _switchRecovery(bool recovery) {
    final auth = Provider.of<Auth>(context, listen: false);

    auth.isRecover = recovery;
    if (recovery) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _pageIndex = 1;
    } else {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      _pageIndex = 0;
    }
  }

  Future<void> runLoadingAnimation() {
    if (widget.loadingController.isDismissed) {
      return widget.loadingController.forward().then((_) {
        if (!_isLoadingFirstTime) {
          _formLoadingController.forward();
        }
      });
    } else if (widget.loadingController.isCompleted) {
      return _formLoadingController
          .reverse()
          .then((_) => widget.loadingController.reverse());
    }
    return Future(null);
  }

  Future<void> _forwardChangeRouteAnimation() {
    final isConfirm = Provider.of<Auth>(context, listen: false).isConfirm;
    final deviceSize = MediaQuery.of(context).size;
    final cardSize = getWidgetSize(_cardKey);
    // add .25 to make sure the scaling will cover the whole screen
    final widthRatio =
        deviceSize.width / cardSize.height + (isConfirm ? .25 : .65);
    final heightRatio = deviceSize.height / cardSize.width + .25;

    _cardSize2AnimationX =
        Tween<double>(begin: 1.0, end: heightRatio / cardSizeScaleEnd)
            .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1, curve: Curves.easeInOutCubic),
    ));
    _cardSize2AnimationY =
        Tween<double>(begin: 1.0, end: widthRatio / cardSizeScaleEnd)
            .animate(CurvedAnimation(
      parent: _routeTransitionController,
      curve: Interval(.72727272, 1, curve: Curves.easeInOutCubic),
    ));

    widget?.onSubmit();

    return _formLoadingController
        .reverse()
        .then((_) => _routeTransitionController.forward());
  }

  void _reverseChangeRouteAnimation() {
    _routeTransitionController
        .reverse()
        .then((_) => _formLoadingController.forward());
  }

  void runChangeRouteAnimation() {
    if (_routeTransitionController.isCompleted) {
      _reverseChangeRouteAnimation();
    } else if (_routeTransitionController.isDismissed) {
      _forwardChangeRouteAnimation();
    }
  }

  void runChangePageAnimation() {
    final auth = Provider.of<Auth>(context, listen: false);
    _switchRecovery(!auth.isRecover);
  }

  Widget _buildLoadingAnimator({Widget child, ThemeData theme}) {
    Widget card;
    Widget overlay;

    // loading at startup
    card = AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) => Transform(
        transform: Matrix.perspective()..rotateX(_flipAnimation.value),
        alignment: Alignment.center,
        child: child,
      ),
      child: child,
    );

    // change-route transition
    overlay = Padding(
      padding: theme.cardTheme.margin,
      child: AnimatedBuilder(
        animation: _cardOverlayHeightFactorAnimation,
        builder: (context, child) => ClipPath.shape(
          shape: theme.cardTheme.shape,
          child: FractionallySizedBox(
            heightFactor: _cardOverlayHeightFactorAnimation.value,
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.accentColor),
        ),
      ),
    );

    overlay = ScaleTransition(
      scale: _cardOverlaySizeAndOpacityAnimation,
      child: FadeTransition(
        opacity: _cardOverlaySizeAndOpacityAnimation,
        child: overlay,
      ),
    );

    return Stack(
      children: <Widget>[
        card,
        Positioned.fill(child: overlay),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    Widget current = Container(
      height: deviceSize.height,
      width: deviceSize.width,
      padding: widget.padding,
      child: TransformerPageView(
        physics: NeverScrollableScrollPhysics(),
        pageController: _pageController,
        itemCount: 2,

        /// Need to keep track of page index because soft keyboard will
        /// make page view rebuilt
        index: _pageIndex,
        transformer: CustomPageTransformer(),
        itemBuilder: (BuildContext context, int index) {
          final child = (index == 0)
              ? _buildLoadingAnimator(
                  theme: theme,
                  child: _LoginCard(
                    key: _cardKey,
                    loadingController: _isLoadingFirstTime
                        ? _formLoadingController
                        : (_formLoadingController..value = 1.0),
                    mobileValidator: widget.mobileValidator,
                    emailValidator: widget.emailValidator,
                    passwordValidator: widget.passwordValidator,
                    onSwitchRecoveryPassword: () => _switchRecovery(true),
                    onSubmitCompleted: () {
                      _forwardChangeRouteAnimation().then((_) {
                        widget.onSubmitCompleted();
                      });
                    },
                  ),
                )
              : _RecoverCard(
                  emailValidator: widget.emailValidator,
                  onSwitchLogin: () => _switchRecovery(false),
                );

          return Align(
            alignment: Alignment.topCenter,
            child: child,
          );
        },
      ),
    );

    return AnimatedBuilder(
      animation: _cardSize2AnimationX,
      builder: (context, snapshot) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_cardRotationAnimation.value)
            ..scale(_cardSizeAnimation.value, _cardSizeAnimation.value)
            ..scale(_cardSize2AnimationX.value, _cardSize2AnimationY.value),
          child: current,
        );
      },
    );
  }
}

class _LoginCard extends StatefulWidget {
  _LoginCard({
    Key key,
    this.loadingController,
    @required this.emailValidator,
    @required this.mobileValidator,
    @required this.passwordValidator,
    @required this.onSwitchRecoveryPassword,
    this.onSwitchAuth,
    this.onSubmitCompleted,
  }) : super(key: key);

  final AnimationController loadingController;
  final FormFieldValidator<String> emailValidator;
  final FormFieldValidator<String> mobileValidator;
  //final FormFieldValidator<String> emailValidator;
  //final FormFieldValidator<String> emailValidator;

  final FormFieldValidator<String> passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function onSwitchAuth;
  final Function onSubmitCompleted;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _currentPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  var _authData = {'userName': '','currentPassword': '','confirmPassword':'', 'password': '','firstName': '', 'lastName': '','mobile': '','securityCode': ''};
  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;

  /// switch between login and signup
  AnimationController _loadingController;
  AnimationController _switchAuthController;
  AnimationController _switchAuthLoginController;
  AnimationController _postSwitchAuthController;
  AnimationController _postSwitchAuthLoginController;

  AnimationController _submitController;

  Interval _nameTextFieldLoadingAnimationInterval;
  Interval _firstnameTextFieldLoadingAnimationInterval;
  Interval _lastnameTextFieldLoadingAnimationInterval;
  Interval _mobileTextFieldLoadingAnimationInterval;

  Interval _passTextFieldLoadingAnimationInterval;
  Interval _textButtonLoadingAnimationInterval;
  Animation<double> _buttonScaleAnimation;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;


  void registerRxBus()
  {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {


      if(event.message=='LOGIN_CHANGED')
      {
        if(event.type=='LOGIN')
          _switchAuthMode();
        if(event.type=='REGISTER')
          _switchAuthMode();
      }


    });
  }
  @override
  void initState() {
    super.initState();
    registerRxBus();
    _loadingController = widget.loadingController ??
        (AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1150),
          reverseDuration: Duration(milliseconds: 300),
        )..value = 1.0);

    _loadingController?.addStatusListener(handleLoadingAnimationStatus);

    _switchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _switchAuthLoginController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _postSwitchAuthLoginController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);
    _buttonScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Interval(.4, 1.0, curve: Curves.easeOutBack),
    ));
    _switchAuthLoginController.forward();
  }

  void handleLoadingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() => _isLoading = true);
    }
    if (status == AnimationStatus.completed) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loadingController?.removeStatusListener(handleLoadingAnimationStatus);
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _currentPasswordFocusNode.dispose();
    _switchAuthController.dispose();
    _switchAuthLoginController.dispose();
    _postSwitchAuthController.dispose();
    _postSwitchAuthLoginController.dispose();
    _submitController.dispose();
  }

  void _switchAuthMode() {
    final auth = Provider.of<Auth>(context, listen: false);
    final newAuthMode = auth.switchAuth();

    if (newAuthMode == AuthMode.Cancel) {
      _submit();
    } else {

      _switchAuthController.reverse();
     /* _switchAuthLoginController.forward();*/
    }
  }

  Future<bool> _submit() async {
    // a hack to force unfocus the soft keyboard. If not, after change-route
    // animation completes, it will trigger rebuilding this widget and show all
    // textfields and buttons again before going to new route
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState.validate()) {
      return false;
    }

    _formKey.currentState.save();
    _submitController.forward();
    setState(() => _isSubmitting = true);
    final auth = Provider.of<Auth>(context, listen: false);
    String error;

    if (auth.isConfirm) {
      error = await auth.onConfirm(LoginData(
        name: '',
        currentPassword: _authData['currentPassword'],
        password: _authData['password'],
        confrimPassword: _authData['confirmPassword'],
        firstName: '',
        lastName: '',
        mobile: '',
        cancel: false
      ));
    } else {
      error = await auth.onCancel(LoginData(
        confrimPassword: '',
        currentPassword: '',
        name: '',//_authData['userName'],
        password:'',// _authData['password'],
        firstName:'',// _authData['firstName'],
        lastName:'',// _authData['lastName'],
        mobile: '',
        cancel: true
      ));
    }

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    _submitController.reverse();

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, error);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      return false;
    }

    widget?.onSubmitCompleted();

    return true;
  }

  _buildFingerPrintLogin() {
    final auth = Provider.of<Auth>(context);
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: IconButton(
        padding: EdgeInsets.all(10.0),
        onPressed: (){

        },
        icon: Icon(Icons.touch_app,color: Colors.redAccent,size: 68.0,),
        alignment: Alignment.center,
      ),
    );
  }

  _buildPatternLogin() {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child:
      IconButton(
        padding: EdgeInsets.all(10.0),
        onPressed: (){

        },
        icon: Icon(Icons.touch_app,color: Colors.redAccent,size: 68.0,),
        alignment: Alignment.center,
      ),





    );
  }

  Widget _buildNameField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);
    return AnimatedTextFormField(
      enabled: auth.isConfirm,
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.usernameHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      //validator: widget.emailValidator,
      onSaved: (value) => _authData['userName'] = value,
    );
  }

  Widget _buildFirstNameField(double width, LoginMessages messages) {
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.firstNameHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
     // validator: widget.emailValidator,
      onSaved: (value) => _authData['firstName'] = value,
    );
  }

  Widget _buildLastNameField(double width, LoginMessages messages) {
    return AnimatedTextFormField(
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.lastNameHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      //validator: widget.emailValidator,
      onSaved: (value) => _authData['lastName'] = value,
    );
  }

  Widget _buildMobileField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);
    return AnimatedTextFormField(
      enabled: auth.isConfirm,
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.mobileHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: null,//widget.mobileValidator,
      onSaved: (value) => _authData['mobile'] = value,
    );
  }
  Widget _buildCurrentPasswordField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedPasswordTextFormField(

      enabled: auth.isConfirm,
      animatedWidth: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.currentPasswordHint,
      controller: _currentPasswordController,
      textInputAction:
      auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _currentPasswordFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        /*if (auth.isLogin) {
          _submit();
        } else {
          // SignUp
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        }*/
      },
      validator: (value) {
        if(auth.isConfirm)
          widget.passwordValidator;
        return null;
      },
      onSaved: (value) => _authData['currentPassword'] = value,
    );
  }

  Widget _buildPasswordField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedPasswordTextFormField(

      enabled: auth.isConfirm,
      animatedWidth: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.passwordHint,
      controller: _passwordController,
      textInputAction:
          auth.isConfirm ? TextInputAction.done : TextInputAction.next,
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (value) {
        _submit();
        /*if (auth.isLogin) {
          _submit();
        } else {
          // SignUp
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        }*/
      },
      validator: (value) {
        if(auth.isConfirm)
          widget.passwordValidator;
        return null;
      },
      onSaved: (value) => _authData['password'] = value,
    );
  }

  Widget _buildConfirmMobileField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);
    return AnimatedTextFormField(
      //enabled: auth.isConfirm,
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.mobileHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: widget.mobileValidator,
      onSaved: (value) => _authData['securityCode'] = value,
    );
  }

  Widget _buildConfirmPasswordField(double width, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      enabled: auth.isConfirm,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.confirmPasswordHint,
      textInputAction: TextInputAction.done,
      focusNode: _confirmPasswordFocusNode,
      onFieldSubmitted: (value) => _submit(),
      onSaved: (value) => _authData['confirmPassword'],
      validator: auth.isConfirm
          ? (value) {
              if (value != _passwordController.text) {
                return messages.confirmPasswordError;
              }
              return null;
            }
          : (value) => null,
    );
  }

  Widget _buildForgotPassword(ThemeData theme, LoginMessages messages) {
    return FadeIn(
      controller: _loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      child: FlatButton(
        child: Text(
          messages.forgotPasswordButton,
          style: theme.textTheme.body1,
          textAlign: TextAlign.left,
        ),
        onPressed: buttonEnabled ? widget.onSwitchRecoveryPassword : null,
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, LoginMessages messages) {
    final auth = Provider.of<Auth>(context);

    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: AnimatedButton(
        controller: _submitController,
        text: auth.isConfirm ? messages.loginButton : messages.signupButton,
        onPressed: _submit,
      ),
    );
  }

  Widget _buildSwitchAuthButton(ThemeData theme, LoginMessages messages) {
    final auth = Provider.of<Auth>(context, listen: false);

    return FadeIn(
      controller: _loadingController,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      fadeDirection: FadeDirection.topToBottom,
      child: FlatButton(
        child: AnimatedText(
          text: auth.isConfirm ? messages.signupButton : messages.loginButton,
          textRotation: AnimatedTextRotation.down,
        ),
        disabledTextColor: theme.primaryColor,
        onPressed: buttonEnabled ? _switchAuthMode : null,
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: theme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConfirm = Provider.of<Auth>(context, listen: false).isConfirm;
    final messages = Provider.of<LoginMessages>(context, listen: false);
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.85, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCurrentPasswordField(textFieldWidth, messages),
                SizedBox(height: 20),
                _buildPasswordField(textFieldWidth, messages),
                SizedBox(height: 10),
                _buildConfirmPasswordField(textFieldWidth, messages),
                SizedBox(height: 10),
              ],
            ),

          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isConfirm
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(
         // horizontal: cardPadding,
          vertical: 20,
        ),
        child:
     // _buildConfirmPasswordField(textFieldWidth, messages),
        _buildMobileField(textFieldWidth, messages),
      ),

    ],
    )

          ),
          Container(
            padding: Paddings.fromRBL(cardPadding),
            width: cardWidth,
            child: Column(
              children: <Widget>[
                //_buildForgotPassword(theme, messages),
                _buildSubmitButton(theme, messages),
                _buildSwitchAuthButton(theme, messages),
              ],
            ),
          ),
        ],
      ),
    );

    return FittedBox(
      child: Card(
        elevation: _showShadow ? 0 /*theme.cardTheme.elevation*/ : 0,
        child: authForm,
      ),
    );
  }
}

class _RecoverCard extends StatefulWidget {
  _RecoverCard({
    Key key,
    @required this.emailValidator,
    @required this.onSwitchLogin,
  }) : super(key: key);

  final FormFieldValidator<String> emailValidator;
  final Function onSwitchLogin;

  @override
  _RecoverCardState createState() => _RecoverCardState();
}

class _RecoverCardState extends State<_RecoverCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formRecoverKey = GlobalKey();

  var _isSubmitting = false;
  var _name = '';

  AnimationController _submitController;

  @override
  void initState() {
    super.initState();

    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _submitController.dispose();
  }

  Future<bool> _submit() async {
    if (!_formRecoverKey.currentState.validate()) {
      return false;
    }
    final auth = Provider.of<Auth>(context, listen: false);
    final messages = Provider.of<LoginMessages>(context, listen: false);

    _formRecoverKey.currentState.save();
    _submitController.forward();
    setState(() => _isSubmitting = true);
    final error = await auth.onRecoverPassword(_name);

    if (error != null) {
      showErrorToast(context, error);
      setState(() => _isSubmitting = false);
      _submitController.reverse();
      return false;
    } else {
      showSuccessToast(context, messages.recoverPasswordSuccess);
      setState(() => _isSubmitting = false);
      _submitController.reverse();
      return true;
    }
  }

  Widget _buildRecoverNameField(double width, LoginMessages messages) {
    return AnimatedTextFormField(
      width: width,
      labelText: messages.usernameHint,
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) => _submit(),
      validator: widget.emailValidator,
      onSaved: (value) => _name = value,
    );
  }

  Widget _buildRecoverButton(ThemeData theme, LoginMessages messages) {
    return AnimatedButton(
      controller: _submitController,
      text: messages.recoverPasswordButton,
      onPressed: !_isSubmitting ? _submit : null,
    );
  }

  Widget _buildBackButton(ThemeData theme, LoginMessages messages) {
    return FlatButton(
      child: Text(messages.goBackButton),
      onPressed: !_isSubmitting ? widget.onSwitchLogin : null,
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textColor: theme.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = Provider.of<LoginMessages>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;

    return FittedBox(
      // width: cardWidth,
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(
            left: cardPadding,
            top: cardPadding + 10.0,
            right: cardPadding,
            bottom: cardPadding,
          ),
          width: cardWidth,
          alignment: Alignment.center,
          child: Form(
            key: _formRecoverKey,
            child: Column(
              children: [
                Text(
                  messages.recoverPasswordIntro,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
                SizedBox(height: 20),
                _buildRecoverNameField(textFieldWidth, messages),
                SizedBox(height: 20),
                Text(
                  messages.recoverPasswordDescription,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
                SizedBox(height: 26),
                _buildRecoverButton(theme, messages),
                _buildBackButton(theme, messages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
