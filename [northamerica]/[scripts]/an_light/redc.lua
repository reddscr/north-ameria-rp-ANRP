local texturesimg = {
{"Flare.png", "coronastar"}}
addEventHandler("onClientResourceStart", resourceRoot, function()
  -- upvalues: texturesimg
  for i = 1, #texturesimg do
    local shader = dxCreateShader("texture.fx")
    engineApplyShaderToWorldTexture(shader, texturesimg[i][2])
    dxSetShaderValue(shader, "gTexture", dxCreateTexture(texturesimg[i][1]))
  end
end
)