using FourierTools, Interpolations

using Random, Plots, LinearAlgebra

function generate_fading_star_image(width, height, radius)
    image = zeros(Float64, height, width)

    x_center = div(width, 2)
    y_center = div(height, 2)

    for y in 1:height
        for x in 1:width
            distance = norm([x - x_center, y - y_center])

            if distance <= radius
                intensity = 1.0 - (distance / radius)
                image[y, x] = intensity
            end
        end
    end

    return image
end

function apply_affine_transformation(image, transformation_matrix)
    height, width = size(image)
    deformed_image = zeros(Float64, height, width)

    for y in 1:height
        for x in 1:width
            point = [x, y, 1]
            x_deformed, y_deformed, _ = transformation_matrix * point
            x_deformed, y_deformed = round(Int, x_deformed), round(Int, y_deformed)

            if 1 <= x_deformed <= width && 1 <= y_deformed <= height
                deformed_image[y_deformed, x_deformed] = image[y, x]
            end
        end
    end

    return deformed_image
end

width = 200
height = 200
radius = 20

star_image = generate_fading_star_image(width, height, radius)

translation = [1 0 0; 0 1 0; 0 0 1]
rotation = [cos(pi / 3) -sin(pi / 3) 0; sin(pi / 3) cos(pi / 3) 0; 0 0 1]
scaling = [1.1 0 0; 0 1.1 0; 0 0 1]
shearing = [1 0.1 0; 0.1 1 0; 0 0 1]

# Combine the transformations
transformation_matrix = translation * rotation #* scaling * shearing

deformed_star_image = apply_affine_transformation(star_image, transformation_matrix)





heatmap(deformed_star_image, aspect_ratio=1)