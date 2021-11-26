program main
    use :: ex_jsonfortran
    implicit none

    call read_sample1_json_and_get_value()
    call read_sample2_json_and_get_numerical_values()
    call create_json_from_string()
end program main
