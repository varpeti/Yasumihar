local env = {}

function env:draw(points,DATA,teamcolor)
	love.graphics.setColor(DATA.szin.rr,DATA.szin.gg,DATA.szin.bb,122)
	love.graphics.polygon("fill",points)
	love.graphics.setColor(teamcolor.rr,teamcolor.gg,teamcolor.bb,255)
	love.graphics.polygon("line",points)

end

return env