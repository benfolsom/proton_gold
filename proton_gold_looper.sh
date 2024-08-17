#!/bin/bash

# Define the arrays for proton_gamma and gold_gamma
proton_gamma=(4269.62045599 4133.4163007 3997.21198793 3861.00802955 3724.80348361 3588.59935616 3452.39531806 3316.19106089 3179.98682498 3043.78235351 2907.57838921 2771.3739171 2635.16990428 2498.96552235 2362.7614881 2226.55726011 2090.35299642 1954.14869654 1817.94440739 1681.74020964 1545.53608154 1409.33185939 1273.12750217 1136.92331738 1000.7190624 864.51492026 728.31037941 592.10626114 455.90207075 319.69785055)

gold_gamma=(21.50419414 20.81799305 20.1320049 19.4462004 18.76027159 18.07466015 17.38903357 16.70332762 16.01766833 15.3319043 14.64592503 13.9599528 13.27415768 12.58829472 11.90221738 11.21609968 10.53003061 9.84399674 9.15780874 8.47174365 7.78562623 7.09957915 6.41338523 5.72713062 5.04094729 4.35505128 3.66886273 2.98247723 2.29635147 1.61042343)

# Original input file
input_file="proton_lead.inp"

# Directory to save runs
save_dir="./saved_runs_alt"

# Loop through the gamma values
for i in "${!proton_gamma[@]}"; do
    # Get the current gamma values
    p_gamma=${proton_gamma[$i]}
    g_gamma=${gold_gamma[$i]}
    
    # Update the input file with the current gamma values
    sed -i "s/^my_constants\.proton_gamma = .*/my_constants.proton_gamma = $p_gamma/" "$input_file"
    sed -i "s/^my_constants\.gold_gamma = .*/my_constants.gold_gamma = $g_gamma/" "$input_file"
    
    # Run the simulation
    warpx.3d "$input_file"
    
    # Round the proton_gamma value to the nearest integer
    p_gamma_rounded=$(printf "%.0f" "$p_gamma")
    
    # Create the new directory based on rounded proton_gamma
    new_dir="$save_dir/gam${p_gamma_rounded}"
    mkdir -p "$new_dir"
    
    # Copy the output files to the new directory
    cp ./diags/reducedfiles/* "$new_dir/"
done
