tetra_cart = 
{
	
	{1, 1, 1},
	
	{-1, -1, 1},
	
	{-1, 1, -1},
	
	{1, -1, -1}

}


tetrafaces = {
	{1, 4, 2},
	{1,2,3},
	{3,2,4},
	{1,3,4}
};

polyhedron(tetra_cart, tetrafaces)
