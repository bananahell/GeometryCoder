function vectorsSelectedMsg(enc)

values = enc.params.BACParams;

firstVector = [values.contextVector2DTIndependent values.contextVector4DTIndependent];
secondVector = [values.contextVector2DTMasked values.contextVector4DTMasked];
thirdVector = [values.contextVector2DTORImages values.contextVector3DTORImages values.contextVector4DTORImages];
fourthVector = [values.contextVector2DT values.contextVector3DT values.contextVector4DT];

disp(['Vector for first image:            ' num2str(firstVector)]);
disp(['Vector for Diadic Masked contexts: ' num2str(secondVector)]);
disp(['Vector for Diadic 4D Contexts:     ' num2str(thirdVector)]);
disp(['Vector for Single 4D Contexts:     ' num2str(fourthVector)]);
disp('                          ')