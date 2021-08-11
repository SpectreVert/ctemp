##
## Created by Costa Bushnaq
##
## 28-07-2021 @ 01:30:01
##
## see LICENSE
##

# >>
# for use in your project, replace all occurences
# of XXX with a suitable prefix.
# >>

# >>
# some utils functions
# >>

# requirements:
#   - having called cmake_parse_arguments before
#
macro(XXX_check_arguments function)
  if (NOT "${ARG_UNPARSED_ARGUMENTS}" STREQUAL "")
    message(FATAL_ERROR "${function}: bad argument(s): ${ARG_UNPARSED_ARGUMENTS}")
  endif()
endmacro()



# requirements:
#   - having called cmake_parse_arguments before
#
macro(XXX_get_root_directory out_variable)
  # by default we set the root directory to src
  if(NOT ARG_ROOT_DIRECTORY)
    set("${out_variable}" src)
  else()
    set("${out_variable}" ${ARG_ROOT_DIRECTORY})
  endif()
endmacro()



function(XXX_get_sources out_variable cwd)
  set(sources)

  foreach(source_path ${ARGN})
    if(IS_ABSOLUTE ${source_path})
      file(GLOB files ${source_path})
    else()
      file(GLOB files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${cwd}/${source_path}")
    endif()
    
    if(files)
      set(sources ${sources} ${files})
    else()
      message(FATAL_ERROR "XXX_get_sources: could not find ${cwd}/${source_path}")
    endif()
  endforeach()

  set("${out_variable}" ${sources} PARENT_SCOPE)
endfunction()

# >>
# the main course
# >>

function(XXX_build_executable target)
  cmake_parse_arguments(ARG "" "ROOT_DIRECTORY" "DEPENDS" ${ARGN})

  XXX_get_root_directory(root_directory)
  XXX_get_sources(sources ${root_directory} ${ARG_UNPARSED_ARGUMENTS})

  add_executable("${target}" ${sources})
endfunction()



function(XXX_build_library target)
  cmake_parse_arguments(ARG "SHARED" "ROOT_DIRECTORY" "DEPENDS" ${ARGN})

  XXX_get_root_directory(root_directory)
  XXX_get_sources(sources ${root_directory} ${ARG_UNPARSED_ARGUMENTS})

  if(ARG_SHARED)
    add_library("${target}" SHARED ${sources})
  else()
    add_library("${target}" ${sources})
  endif()

  if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions("${target}" PUBLIC "XXX_STATIC")
  endif()
endfunction()

function(XXX_add_test target)
  cmake_parse_arguments(ARG "" "" "" ${ARGN})

  XXX_check_arguments("XXX_add_test")
endfunction()
