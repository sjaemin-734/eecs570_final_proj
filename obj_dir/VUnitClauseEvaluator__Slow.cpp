// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VUnitClauseEvaluator.h for the primary calling header

#include "VUnitClauseEvaluator.h"
#include "VUnitClauseEvaluator__Syms.h"

//==========
CData/*2:0*/ VUnitClauseEvaluator::__Vtable1_UnitClauseEvaluator__DOT__encoded_position[32];
CData/*0:0*/ VUnitClauseEvaluator::__Vtable1_UnitClauseEvaluator__DOT__valid_unit[32];

VL_CTOR_IMP(VUnitClauseEvaluator) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = __VlSymsp = new VUnitClauseEvaluator__Syms(this, name());
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VUnitClauseEvaluator::__Vconfigure(VUnitClauseEvaluator__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

VUnitClauseEvaluator::~VUnitClauseEvaluator() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void VUnitClauseEvaluator::_eval_initial(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_eval_initial\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VUnitClauseEvaluator::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::final\n"); );
    // Variables
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = this->__VlSymsp;
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VUnitClauseEvaluator::_eval_settle(VUnitClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_eval_settle\n"); );
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

void VUnitClauseEvaluator::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VUnitClauseEvaluator::_ctor_var_reset\n"); );
    // Body
    clause_mask = VL_RAND_RESET_I(5);
    unassign = VL_RAND_RESET_I(5);
    clause_pole = VL_RAND_RESET_I(5);
    implied_variable = VL_RAND_RESET_I(3);
    new_assignment = VL_RAND_RESET_I(1);
    unit_clause = VL_RAND_RESET_I(1);
    UnitClauseEvaluator__DOT__encoded_position = VL_RAND_RESET_I(3);
    UnitClauseEvaluator__DOT__valid_unit = VL_RAND_RESET_I(1);
    __Vtableidx1 = 0;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[0] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[1] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[2] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[3] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[4] = 2U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[5] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[6] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[7] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[8] = 3U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[9] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[10] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[11] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[12] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[13] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[14] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[15] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[16] = 4U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[17] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[18] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[19] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[20] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[21] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[22] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[23] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[24] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[25] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[26] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[27] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[28] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[29] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[30] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__encoded_position[31] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[0] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[1] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[2] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[3] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[4] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[5] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[6] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[7] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[8] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[9] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[10] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[11] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[12] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[13] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[14] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[15] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[16] = 1U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[17] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[18] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[19] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[20] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[21] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[22] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[23] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[24] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[25] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[26] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[27] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[28] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[29] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[30] = 0U;
    __Vtable1_UnitClauseEvaluator__DOT__valid_unit[31] = 0U;
    { int __Vi0=0; for (; __Vi0<1; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
