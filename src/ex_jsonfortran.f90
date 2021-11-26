module ex_jsonfortran
    use, intrinsic :: iso_fortran_env
    use :: json_module
    implicit none
    private
    public :: read_sample1_json_and_get_value
    public :: read_sample2_json_and_get_numerical_values
    public :: create_json_from_string

contains
    !| sample1.jsonを読み込んでkeyの値を取得する例．
    subroutine read_sample1_json_and_get_value()
        type(json_file) :: json

        ! json_fileを初期化する．
        call json%initialize()

        ! sample1.jsonを読み込み．
        call json%load(filename="sample1.json")

        block
            character(:), allocatable :: value

            ! オブジェクトのキーを指定して値を取得し，valueに代入する．
            ! value
            call json%get("key", value)
            print *, value
        end block

        block
            logical :: found
            character(:), allocatable :: value

            ! 追加のオプションfound, defaultの指定．
            ! キー "key"が存在していればfoundに.true.が代入される．
            ! defaultが指定されていれば，キーが存在していない場合に値がdefaultで指定された値に設定される．

            ! key is found and value is value
            call json%get("key", value, found=found, default="N/A")
            if (found) then
                print *, "key is found and value is ", value
            end if

            ! Key is not found, value is set to N/A
            call json%get("Key", value, found=found, default="N/A")
            if (.not. found) then
                print *, "Key is not found, value is set to ", value
            end if
        end block

        ! json_fileを破棄
        call json%destroy()
    end subroutine read_sample1_json_and_get_value

    !| sample2.jsonを読み込んで，数値や配列を取得する例．
    subroutine read_sample2_json_and_get_numerical_values()
        type(json_file) :: json

        ! json_fileを初期化する．
        call json%initialize()

        ! sample2.jsonを読み込み．
        call json%load(filename="sample2.json")

        get_val: block
            block
                integer(int32) :: i

                ! 整数値を読み込み．
                ! オブジェクトを入れ子にした場合は，キーの名前を.で連結する．
                ! value.integer           1
                call json%get("value.integer", i)
                print *, "value.integer", i
            end block

            block
                real(real64) :: f

                ! 実数値を読み込み．
                ! 実数は全て倍精度として取り扱われる．
                ! キーの名前は文字列なので，空白があっても問題ない．
                ! value.real.standard notation   1.0000000000000000
                call json%get("value.real.standard notation", f)
                print *, "value.real.standard notation", f

                ! 指数表記の実数値を読み込み．通常表記と区別する必要はない．
                ! 指数の記号はeを用いる．
                ! value.real.exponential notation   1.0000000000000000E-004
                call json%get("value.real.exponential notation", f)
                print *, "value.real.exponential notation", f
            end block

            block
                character(:), allocatable :: s

                ! 文字列を読み込み．
                ! 変数の型はcharacter(:), allocatableとし，手続get内で自動的に割り付けられる．
                ! value.string str
                call json%get("value.string", s)
                print *, "value.string ", s
            end block

            block
                logical :: l
                character(:), allocatable :: s

                ! 論理値を読み込み．
                ! value.logical T
                call json%get("value.logical", l)
                print *, "value.logical", l

                ! 論理値は文字列で書かれているので，文字列としても読み込める．
                ! value.logical as string true
                call json%get("value.logical", s)
                print *, "value.logical as string ", s
            end block
        end block get_val

        get_array: block
            block
                integer(int32), allocatable :: i(:)

                ! 整数の配列を取得．
                ! 要素数はget内で自動的に割り付けられる．
                ! array.integer          10           9           8           7
                call json%get("array.integer", i)
                print *, "array.integer", i
            end block

            block
                real(real64), allocatable :: f(:)

                ! 実数の配列を取得．
                ! 要素数はget内で自動的に割り付けられる．
                ! array.real   6.0000000000000000        5.0000000000000000        4.0000000000000000
                call json%get("array.real", f)
                print *, "array.real", f
            end block

            block
                character(16), allocatable :: s(:)

                ! 文字列の配列．
                ! 文字列の配列の場合，配列要素数はget内で自動的に決定されるが，文字列の長さは動的には変更できない．
                ! そのため，文字列の長さを固定している．
                ! array.string 3               2               1               -1
                call json%get("array.string", s)
                print *, "array.string ", s
            end block
        end block get_array

        ! json_fileを破棄
        call json%destroy()
    end subroutine read_sample2_json_and_get_numerical_values

    !| 文字列からjsonを取り扱うオブジェクトを生成する例．
    subroutine create_json_from_string()

        type(json_file) :: json

        character(1), parameter :: LF = achar(int(z'0A')) !! NL line feed, new line

        character(:), allocatable :: json_string

        ! jsonの書式に沿って文字列を作る．
        ! {
        ! "value":{
        ! "integer":2,
        ! "real":1e+1,
        ! "string":"str",
        ! "logical":"false"
        ! }
        ! }
        json_string = "{"//LF
        json_string = json_string//'"value":{'//LF
        json_string = json_string//'"integer":2,'//LF
        json_string = json_string//'"real":1e+1,'//LF
        json_string = json_string//'"string":"str",'//LF
        json_string = json_string//'"logical":"false"'//LF
        json_string = json_string//"}"//LF
        json_string = json_string//"}"
        print *, json_string

        ! json_fileを初期化する．
        call json%initialize()

        ! 文字列をjson書式として読み込み，解釈してjson_fileを作る．
        call json%deserialize(json_string)

        ! エラーを指定の装置（ここでは標準出力）に出力する．
        call json%print_error_message(output_unit)

        block

            block
                integer(int32) :: i

                ! 整数値を読み込み．
                ! value.integer            2
                call json%get("value.integer", i)
                print *, "value.integer ", i
            end block

            block
                real(real64) :: f

                ! 実数値を読み込み．
                ! value.real    10.000000000000000
                call json%get("value.real", f)
                print *, "value.real ", f
            end block

            block
                character(:), allocatable :: s

                ! 文字列を読み込み．
                ! value.string str
                call json%get("value.string", s)
                print *, "value.string ", s
            end block

            block
                logical :: l

                ! 論理値を読み込み．
                ! value.logical  F
                call json%get("value.logical", l, default=.true.)
                print *, "value.logical ", l
            end block
        end block

        call json%destroy()
    end subroutine create_json_from_string
end module ex_jsonfortran
