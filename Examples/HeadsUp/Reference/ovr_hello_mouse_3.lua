function setup()
       size(400, 400);
       stroke(255);
     end
		  
     function draw()
       line(150, 25, mouseX, mouseY);
     end
     
     function mousePressed()
       background(192, 64, 0);
     end