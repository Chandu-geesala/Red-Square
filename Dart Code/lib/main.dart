import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MovingSquareApp());
}

class MovingSquareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moving Square',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Moving Square')),
        body: SquareMovement(),
      ),
    );
  }
}

class SquareMovement extends StatefulWidget {
  @override
  _SquareMovementState createState() => _SquareMovementState();
}

class _SquareMovementState extends State<SquareMovement> {
  // Square's horizontal position (X-axis)
  double _currentPositionX = 0;

  // Size of the square
  final double _squareSize = 50;

  // Timer to handle movement updates
  Timer? _movementTimer;

  // Flag to check if square is moving
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    // Initializing square position in the center of the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPositionX = (MediaQuery.of(context).size.width / 2) - (_squareSize / 2);
      });
    });
  }

  // Move square to the left
  void _moveSquareLeft() {
    if (_isMoving) return; // Prevent movement if already in motion
    _isMoving = true;

    // Start a timer to update square position periodically
    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        // If square can still move left, update its position
        if (_currentPositionX > 0) {
          _currentPositionX -= 20;
          if (_currentPositionX <= 0) {
            _currentPositionX = 0; // Stop at leftmost point
            _stopMovement();
          }
        } else {
          _stopMovement();
        }
      });
    });
  }

  // Move square to the right
  void _moveSquareRight() {
    if (_isMoving) return; // Prevent movement if already in motion
    _isMoving = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxPositionX = screenWidth - _squareSize;

    // Start a timer to update square position periodically
    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        // If square can still move right, update its position
        if (_currentPositionX < maxPositionX) {
          _currentPositionX += 20;
          if (_currentPositionX >= maxPositionX) {
            _currentPositionX = maxPositionX; // Stop at rightmost point
            _stopMovement();
          }
        } else {
          _stopMovement();
        }
      });
    });
  }

  // Stop square's movement
  void _stopMovement() {
    _movementTimer?.cancel(); // Cancel the movement timer
    _movementTimer = null;
    setState(() {
      _isMoving = false; // Update moving status
    });
  }

  @override
  Widget build(BuildContext context) {
    final double buttonContainerWidth = 200;

    return Center(
      child: Stack(
        children: [
          // Animated square that moves horizontally
          AnimatedPositioned(
            left: _currentPositionX,
            duration: Duration(milliseconds: 100),
            child: Container(
              width: _squareSize,
              height: _squareSize,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          // Row with buttons to move the square
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - buttonContainerWidth / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button to move the square left
                ElevatedButton(
                  onPressed: (_isMoving || _currentPositionX <= 0) ? null : _moveSquareLeft,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor:
                    (_isMoving || _currentPositionX <= 0) ? Colors.transparent : Colors.blueAccent,
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.all(Colors.blue.shade700),
                    elevation: MaterialStateProperty.all(5),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:
                      LinearGradient(colors: [Colors.red, Colors.orange]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Move Left',
                      style:
                      TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Button to move the square right
                ElevatedButton(
                  onPressed:
                  (_isMoving || _currentPositionX >= (MediaQuery.of(context).size.width - _squareSize))
                      ? null : _moveSquareRight,
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor:
                    (_isMoving || _currentPositionX >= (MediaQuery.of(context).size.width - _squareSize))
                        ? Colors.transparent : Colors.blueAccent,
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    overlayColor:
                    MaterialStateProperty.all(Colors.blue.shade700),
                    elevation:
                    MaterialStateProperty.all(5),
                    shape:
                    MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    )),
                  ),
                  child:
                  Container(
                    decoration:
                    BoxDecoration(
                      gradient:
                      LinearGradient(colors:[Colors.orange, Colors.red]),
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow:[
                        BoxShadow(
                          color:
                          Colors.black26,
                          blurRadius:
                          4,
                          offset:
                          Offset(2,2),
                        )
                      ],
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal:
                    20, vertical:
                    10),
                    child:
                    Text('Move Right',
                        style:
                        TextStyle(color:
                        Colors.white, fontSize:
                        18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}