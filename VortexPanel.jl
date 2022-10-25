
# using CUDA

function Circle(N::Int64)
    theta = Array(range(0, 2pi, N))
    x = map(cos, theta)
    y = map(sin, theta)
    return x, y
end

function Panelise(x, y)
    # return anonymous functions as a named tuple
    dx() = (diff(x)/2)
    dy() = (diff(y)/2)

    new_x = copy(x)
    pop!(new_x)
    new_y = copy(y)
    pop!(new_y)

    xc() = (new_x.+dx())
    yc() = (new_y.+dy())
    S() = ((dx().^2+dy().^2).^0.5)
    sx() = (dx()./S())
    sy() = (dy()./S())
    ()->(xc;yc;dx;dy;S;sx;sy)
end

function SolveGamma()

end

function ConstructSystem(x,y)
    # Construct the linear system that enforces no-slip on each panel.
    panels = Panelise(x,y)
    A = Array(undef, (length(panels.xc(), length(panels.xc()))))
end    

function Constant

end

function Transform(x,y)
    "transform from global to panel coordinates"
    xt = x-self.xc; yt = y-self.yc # shift x,y
    xp = xt*self.sx+yt*self.sy     # rotate x
    yp = yt*self.sx-xt*self.sy     # rotate y
    lr = 0.5*np.log(((xp-self.S)**2+yp**2)/((xp+self.S)**2+yp**2))
    dt = np.arctan2(yp,xp-self.S)-np.arctan2(yp,xp+self.S)
    return lr, dt, xp, yp
end


function main()
    panels = Panelise(Circle(32)[1], Circle(32)[2])
    print((panels.xc()))
end

main()

# function _constant(x, y)
#         lr, dt, _, _ = _transform_xy(x, y)
#         return _rotate_uv(-dt*0.5/pi, -lr*0.5/pi)
# end

# function _linear(x, y)
#     lr, dt, xp, yp = _transform_xy(x, y)
#     g, h, c = (yp*lr+xp*dt)/self.S, (xp*lr-yp*dt)/self.S+2, 0.25/\pi
#     return (_rotate_uv(c*( g-dt), c*( h-lr))
#             +_rotate_uv(c*(-g-dt), c*(-h-lr)))
# end

# function _transform_xy(self, x, y)
#     xt = x-self.xc; yt = y-self.yc # shift x,y
#     xp = xt*self.sx+yt*self.sy     # rotate x
#     yp = yt*self.sx-xt*self.sy     # rotate y
#     lr = 0.5*np.log(((xp-self.S)**2+yp**2)/((xp+self.S)**2+yp**2))
#     dt = np.arctan2(yp,xp-self.S)-np.arctan2(yp,xp+self.S)
#     return lr, dt, xp, yp
# end

# function _rotate_uv(self, up, vp)
#     u = up*self.sx-vp*self.sy    # reverse rotate u prime
#     v = vp*self.sx+up*self.sy    # reverse rotate v prime
#     return u, v
# end

