# Maze
A nifty maze app with a joystick to move around

   Hello and welcome to my maze. Mine is very different from others' in the sense that I added a joystick!
   
   To accomplish this, I made my own custom SKNode. I used one shape node as the inside "stick" and another shape node as the movement circle.
      
   Moving your finger while touching the stick moves the stick, but it checks that it's always in the outer ring.
   
   The joystick sends a delegate call back with a vector of the direction the stick is pointed.
   
   The magnitude of the vector is 1 when the stick is at it's furthest position.
   
   The joystick is my favorite addition and I wrote it in such a way that I can just take that file and move it to future projects.
   - I also added haptic feedback to the joystick (fun!)
   
   I also enabled dark mode in my game (but it won't change mid game cuz hard (also changing it actually makes you not able to move lol))
   
   There are 50 different mazes I took from mazegenerator.net that randomize.
   
   There is an easter egg where if you try to get out the top of the maze, you can re randomize the maze.
   
   Collision works by checking the color of pixels in a cross shape.
   - It returns which side(s) it detects the walls on and then prevents from moving in that direction.
   - This lets the player still move along walls with the joystick instead of being stopped when touching a wall with the only option being moving directly away from the wall.
   
   The timer works as you would expect.
   
   Finally, you win by getting to the end of the maze and attempting to escape, and you can then tap to play again.
   
   The only bugs I've noticed is switching dark mode mid game, everything else should work fine.
