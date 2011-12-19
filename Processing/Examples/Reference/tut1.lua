function setup()
  size(480, 120);
end

function draw()
  if (isMousePressed) then
    fill(0);
  else 
    fill(255);
  end
  ellipse(mouseX, mouseY, 80, 80);
end