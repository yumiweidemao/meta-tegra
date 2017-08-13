CUDA_COMMON_LD_FLAGS = " \
  -Wl,-rpath-link,${STAGING_DIR_TARGET}/usr/local/cuda-${CUDA_VERSION}/lib \
  -Wl,-rpath,/usr/local/cuda-${CUDA_VERSION}/lib \
"

CUDA_COMMON_CMAKE = " \
  -DCUDA_TOOLKIT_TARGET_DIR=${STAGING_DIR_TARGET}/usr/local/cuda-${CUDA_VERSION} \
  -DCUDA_TOOLKIT_TARGET_DIR_INTERNAL=${STAGING_DIR_TARGET}/usr/local/cuda-${CUDA_VERSION} \
  -DCUDA_TOOLKIT_ROOT_DIR=${STAGING_DIR_NATIVE}/usr/local/cuda-${CUDA_VERSION} \
  -DCUDA_TOOLKIT_ROOT_DIR_INTERNAL=${STAGING_DIR_NATIVE}/usr/local/cuda-${CUDA_VERSION} \
"

CUDA_COMMON_DEPENDS = " cuda-toolkit cuda-tools-native"

DEPENDS_append = "${@bb.utils.contains('MACHINE_FEATURES', 'cuda', ' ${CUDA_COMMON_DEPENDS}', '', d)}"
LDFLAGS_append = "${@bb.utils.contains('MACHINE_FEATURES', 'cuda', ' ${CUDA_COMMON_LD_FLAGS}', '', d)}"
EXTRA_OECMAKE_append = "${@bb.utils.contains('MACHINE_FEATURES', 'cuda', ' ${CUDA_COMMON_CMAKE}', '', d)}"

PACKAGE_ARCH_tegra210 = "${SOC_FAMILY_PKGARCH}"
PACKAGE_ARCH_tegra124 = "${SOC_FAMILY_PKGARCH}"
PACKAGE_ARCH_tegra186 = "${SOC_FAMILY_PKGARCH}"

cmake_do_generate_toolchain_file_append() {
    cat >> ${WORKDIR}/toolchain.cmake <<EOF
if(NOT COMMAND find_host_package)
  macro(find_host_package)
    find_package(\${ARGN})
  endmacro()
endif()
if(NOT COMMAND find_host_program)
  macro(find_host_program)
    find_program(\${ARGN})
  endmacro()
endif()
EOF
}
