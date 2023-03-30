using FourierTools, FFTW, PaddedViews, OffsetArrays

using Random

arr1 = rand(5, 5)

@time arr_resampled = resample(arr1, (1000, 1000))

plot(heatmap(abs.(arr1), aspect_ratio=1), heatmap(abs.(arr_resampled), aspect_ratio=1))


arr_fft = ffts(arr1)


function zeropad(array::Array{T, N}, pad_width::NTuple{N, Int}) where {T, N}
    padded_shape = size(array) .+ 2 .* pad_width
    padded_array = zeros(T, padded_shape)
    
    slices = ntuple(i -> (pad_width[i]+1):(size(array, i)+pad_width[i]), N)
    padded_array[slices...] = array
    
    return padded_array
end

@time padded_arr_fft = abs.(iffts(collect(zeropad(collect(ffts(arr1)), (1000, 1000)))));

plot(heatmap(abs.(arr1), aspect_ratio=1), heatmap(abs.(arr_resampled), aspect_ratio=1))