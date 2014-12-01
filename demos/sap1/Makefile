generic_router: 
	vgen -t Router -o out/generic_router build/generic_router.rb 
chip1_router: 
	vgen -t Router -o out/chip1_router build/chip1_router.rb 
chip2_router: chip1_router 
	vgen -t Chip2_router -o out/chip2_router build/chip2_router.rb 

.PHONY: clean
clean:
	rm -rf out

