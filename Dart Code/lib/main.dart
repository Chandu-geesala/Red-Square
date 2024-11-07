import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MovingSquareApp());
}

// Main app widget
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

// Stateful widget to manage square movement
class SquareMovement extends StatefulWidget {
  @override
  _SquareMovementState createState() => _SquareMovementState();
}

class _SquareMovementState extends State<SquareMovement> {
  // square's position (x-axis)
  double _currentPositionX = 0;

  // just a random size for the square
  final double _squareSize = 50;

  // Timer for smooth movement
  Timer? _movementTimer;

  // flag to indicate if square is already moving
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    // Center the square after the frame is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPositionX = (MediaQuery.of(context).size.width / 2) - (_squareSize / 2);
      });
    });
  }

  // Move square to the left if possible
  void _moveSqrLeft() {
    if (_isMoving) return; // avoid multiple calls if already moving
    _isMoving = true;

    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_currentPositionX > 0) {
          _currentPositionX -= 20;
          if (_currentPositionX <= 0) {
            _currentPositionX = 0;
            _stopMovement(); // stops once leftmost edge is reached
          }
        } else {
          _stopMovement();
        }
      });
    });
  }

  // Move square to the right if possible
  void _moveSqrRight() {
    if (_isMoving) return; // avoid multiple calls if already moving
    _isMoving = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxPositionX = screenWidth - _squareSize;

    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_currentPositionX < maxPositionX) {
          _currentPositionX += 20;
          if (_currentPositionX >= maxPositionX) {
            _currentPositionX = maxPositionX;
            _stopMovement(); // stops once rightmost edge is reached
          }
        } else {
          _stopMovement();
        }
      });
    });
  }

  // Stop the square's movement
  void _stopMovement() {
    _movementTimer?.cancel();
    _movementTimer = null;
    setState(() {
      _isMoving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonContainerWidth = 200; // space for the buttons

    return Center(
      child: Stack(
        children: [
          // Square that moves with animated positioning
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
          // Control buttons for left and right movement
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - buttonContainerWidth / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left button
                ElevatedButton(
                  onPressed: (_isMoving || _currentPositionX <= 0) ? null : _moveSqrLeft,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: (_isMoving || _currentPositionX <= 0) ? Colors.transparent : Colors.blueAccent,
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
                      gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Move Left',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Right button
                ElevatedButton(
                  onPressed: (_isMoving || _currentPositionX >= (MediaQuery.of(context).size.width - _squareSize)) ? null : _moveSqrRight,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: (_isMoving || _currentPositionX >= (MediaQuery.of(context).size.width - _squareSize)) ? Colors.transparent : Colors.blueAccent,
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
                      gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Move Right',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
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
