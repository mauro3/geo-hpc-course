using Plots, Printf
pyplot()
viz = true

@views function heat_2D()
	# physics
	lx   = 10.0
	ly   = 10.0
	λ    = 1.0
	ρCp  = 1.0
	nt   = 200
	# numerics
	nx   = 127
	ny   = 127
	nout = 10
	∂x   = lx/nx
	∂y   = ly/ny
	xc   = LinRange(∂x/2, lx-∂x/2, nx)
	yc   = LinRange(∂y/2, ly-∂y/2, ny)
	🔥   = zeros(nx  ,ny  )
	qx   = zeros(nx+1,ny  )
	qy   = zeros(nx  ,ny+1)
	🔥   = exp.(.-(xc.-lx./2.0).^2 .-(yc.-ly./2.0)'.^2)
	∂t   = min(∂x^2,∂y^2)/ρCp/λ/4.1
	# action
	t0   = Base.time()
	for it = 1:nt
		for iy=1:ny
			for ix=2:nx
				qx[ix,iy] = -λ*(🔥[ix,iy]-🔥[ix-1,iy])/∂x
			end
		end
		for iy=2:ny
			for ix=1:nx
				qy[ix,iy] = -λ*(🔥[ix,iy]-🔥[ix,iy-1])/∂y
			end
		end
		for iy=1:ny
			for ix=1:nx
				🔥[ix,iy] = 🔥[ix,iy] - ∂t/ρCp*((qx[ix+1,iy]-qx[ix,iy])/∂x + (qy[ix,iy+1]-qy[ix,iy])/∂y)
			end
		end
		if mod(it,nout)==0 && viz
			display(heatmap(xc, yc, 🔥', xlabel="lx", ylabel="ly", title="heat diffusion, it=$it", clims=(0.,1.)))
			# sleep(.01)
		end
	end
	@printf("T_eff = %1.2e GB/s \n", (2/1e9*nx*ny*sizeof(lx))/((Base.time()-t0)/nt))
	return
end

@time heat_2D()
