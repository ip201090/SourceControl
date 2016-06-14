function f = goalFunction(averageGradient,inhomogeneityFactor)

f = 8./abs(averageGradient) + inhomogeneityFactor - ...
    8./abs(averageGradient)*averageGradient;

end