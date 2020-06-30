vector = { }
vector.up = {
  x = 0,
  y = -1
}
vector.down = {
  x = 0,
  y = 1
}
vector.left = {
  x = -1,
  y = 0
}
vector.right = {
  x = 1,
  y = 0
}
vector.bezier2 = function(start, control, finish, progress)
  local sc_mid = vector.lerp(start, control, progress)
  local cf_mid = vector.lerp(control, finish, progress)
  return vector.lerp(sc_mid, cf_mid, progress)
end
vector.bezier3 = function(start, control1, control2, finish, progress)
  local sc_mid = vector.lerp(start, control1, progress)
  local cd_mid = vector.lerp(control1, control2, progress)
  local df_mid = vector.lerp(control2, finish, progress)
  local sc_cd_mid = vector.lerp(sc_mid, cd_mid, progress)
  local cd_df_mid = vector.lerp(cd_mid, df_mid, progress)
  return vector.lerp(sc_cd_mid, cd_df_mid, progress)
end
vector.add = function(a, b)
  return {
    x = a.x + b.x,
    y = a.y + b.y
  }
end
vector.sub = function(a, b)
  return {
    x = a.x - b.x,
    y = a.y - b.y
  }
end
vector.mult = function(a, b)
  local _exp_0 = type(b)
  if "number" == _exp_0 then
    return {
      x = a.x * b,
      y = a.y * b
    }
  elseif "table" == _exp_0 then
    return {
      x = a.x * b.x,
      y = a.y * b.y
    }
  else
    return error("Invalid type")
  end
end
vector.div = function(a, b)
  local _exp_0 = type(b)
  if "number" == _exp_0 then
    return {
      x = a.x / b,
      y = a.y / b
    }
  elseif "table" == _exp_0 then
    return {
      x = a.x / b.x,
      y = a.y / b.y
    }
  else
    return error("Invalid type")
  end
end
vector.midpoint = function(a, b)
  return {
    x = (a.x + b.x) / 2,
    y = (a.y + b.y) / 2
  }
end
vector.lerp = function(a, b, progress)
  return {
    x = b.x * progress + a.x * (1 - progress),
    y = b.y * progress + a.y * (1 - progress)
  }
end
vector.tostring = function(x)
  return "x:" .. tostring(x.x) .. " y:" .. tostring(x.y)
end
