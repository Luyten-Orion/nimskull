type
  # xxx: these categories are likely all off, just like severities, see
  #      `ReportSeverity` below for the bigger explaination.
  ReportCategory* = enum
    ## Kinds of the toplevel reports. Only dispatches on report topics,
    ## such as sem, parse, macro (for `echo` in compile-time code) and so
    ## on. Subdivision is based on different phases of the compiler
    ## operation, and not on report's state itself, as those are completely
    ## orthogonal to each other (lexer might provide errors and hints,
    ## parser can provide errors, hints and warnings)

    repParser = "Parser"
    repLexer = "Lexer" ## Report generated by lexer - bad tokens, lines
    ## that are too long etc.

    repSem = "Sem" ## Report produced directly by semantic analysis -
    ## compilation errors, warnings and hints

    repCmd = "Cmd" ## Report related to execution of the external command -
    ## start of the command, execution failure, succes and so on.

    repVM = "VM" ## Report related to embedded virtual machine

    repDebug = "Debug" ## Side channel for the compiler debug report. Helper
    ## messages designed specifically to aid development of the compiler

    repInternal = "Internal" ## Reports constructed during handling of
    ## internal compilation errors. Separate from debugging reports since
    ## they always exist - ICE, internal fatal errors etc.

    repBackend = "Backend" ## Backend-specific reports.

    repExternal = "External" ## Report constructed during handling of
                             ## configuration, packages, modules.


  # TODO: "severity" in such a general fashion barely makes sense. Since
  #       "reports" over reach and cover all "compiler" output it's off. This
  #       includes cli help messages and those could be supressed with these or
  #       need convoluted conditional checks? Then there is the fact that there
  #       are a ton of contexts that the "compiler" works in:
  #       - suite of sub-commands via the CLI
  #       - session based (ie: suggest)
  #       - independent VM
  #       - or while compiling/interpreting, there are comptime effects (echo)
  ReportSeverity* = enum
    rsevDebug = "Debug" ## Internal compiler debug information

    rsevHint = "Hint" ## User-targeted hint
    rsevWarning = "Warning" ## User-targeted warnings
    rsevError = "Error" ## User-targeted error

    rsevFatal = "Fatal"
    rsevTrace = "Trace" ## Additional information about compiler actions -
    ## external commands mostly.


  # xxx: based on how categories and severity shake up, this super enum should
  #      be broken up
  ReportKind* = enum
    ## Toplevel enum for different categories. Order of definitions is
    ## really important - elements are first separated into categories
    ## (internal reports, backend reports and so on) and can be further
    ## split into severity levels.
    ##
    ## Different naming scheme is used for a reports with different
    ## categories - this enum exists only to make it easier to work with
    ## different report kinds, without having to manage seven different
    ## enum types.

    repNone

    #--------------------------  Internal reports  ---------------------------#
    # Internal reports begin
    # fatal errors begin
    rintUnreachable ## State in the compiler code that must not be reached
    rintAssert ## Failed internal assert in the compiler
    # fatal end

    # errors being
    rintCannotOpenFile
    rintUsingLeanCompiler
    rintNotUsingNimcore
    rintNotImplemented
    # errors END. !! add reports BEFORE the last enum !!

    # warnings begin
    rintWarnCannotOpenFile
    rintUnexpected
    rintWarnFileChanged
    # warnings END !! add reports BEFORE the last enum !!

    # hints start
    rintSource = "Source" ## Show source in the report
                          # REFACTOR this is a global configuration option,
                          # not a hint.
    rintMsgOrigin = "MsgOrigin" # REFACTOR this is a global option not a hint
    rintErrKind = "ErrKind" ## Show report kind in error messages
                            # REFACTOR this is a global option not a hint

    rintQuitCalled = "QuitCalled" ## `quit()` called by the macro code
    ## compilation error handling and similar
    rintMissingStackTrace ## Stack trace would've been generated in the
    ## debug compiler build

    rintSuccessX = "SuccessX" ## Successful compilation, only used as a "note",
                              ## it's not a hint either
    # hints END !! add reports BEFORE the last enum !!

    rintStackTrace = "StackTrace" ## Stack trace during internal
    rintListWarnings
    rintListHints

    rintEchoMessage # last !

    # internal reports END !! add reports BEFORE the last enum !!

    #--------------------------  External reports  ---------------------------#
    # External reports
    # errors begin
    rextCmdRequiresFile ## fatal error, user failed to provide a file
    # errors END !! add reports BEFORE the last enum !!

    # hints start
    rextConf = "Conf" ## Processed user configutation file; not a "report"
    rextPath = "Path" ## Add nimble path; xxx: this isn't a "report"
    # hints END !! add reports BEFORE the last enum !!

    # external reports END !! add reports BEFORE the last enum !!

    #----------------------------  Lexer reports  ----------------------------#
    # Lexer report begin
    # errors begin
    rlexMalformedNumUnderscores
    rlexMalformedIdentUnderscores
    rlexMalformedTrailingUnderscre
    rlexInvalidToken
    rlexInvalidTokenSpaceBetweenNumAndIdent
    rlexNoTabs

    # numbers
    rlexInvalidIntegerLiteralOctalPrefix
    rlexInvalidIntegerSuffix
    rlexNumberNotInRange
    rlexExpectedHex
    rlexInvalidIntegerLiteral
    rlexInvalidNumericLiteral

    # char
    rlexInvalidCharLiteral
    rlexInvalidCharLiteralConstant
    rlexInvalidCharLiteralPlatformNewline
    rlexInvalidCharLiteralUnicodeCodepoint
    rlexMissingClosingApostrophe
    rlexInvalidUnicodeCodepointEmpty
    rlexInvalidUnicodeCodepointGreaterThan0x10FFFF

    # string
    rlexUnclosedTripleString
    rlexUnclosedSingleString

    # comments
    rlexUnclosedComment

    # errors end

    # warnings begin
    rlexDeprecatedOctalPrefix = "OctalEscape"
    # warnings end

    # hints begin
    rlexLineTooLong = "LineTooLong"
    rlexLinterReport = "Name"

    rlexSourceCodeFilterOutput = "SourceCodeFilterOutput"
    # hints END !! add reports BEFORE the last enum !!

    # Lexer report end

    #---------------------------  Parser reports  ----------------------------#
    # errors begin
    # regular nim parser
    rparInvalidIndentation
    rparInvalidIndentationWithForgotEqualSignHint
    rparNestableRequiresIndentation

    rparIdentExpected
    rparIdentExpectedEmptyAccQuote
    rparExprExpected
    rparMissingToken         # also used in filter_tmpl
    rparUnexpectedToken
    rparAsmStmtExpectsStrLit

    rparFuncNotAllowed
    rparTupleTypeWithPar
    rparMisplacedParameterVar
    rparConceptNotinType
    rparMisplacedExport

    rparPragmaBeforeGenericParameters

    # source filter template parser `filter_tmpl.nim`
    rparTemplMissingEndClose
    rparTemplInvalidExpression

    # source filter `syntaxes.nim`
    rparInvalidFilter

    # erorrs END !! add reports BEFORE the last enum !!

    # warnings begin
    rparInconsistentSpacing = "Spacing"
    rparPragmaNotFollowingTypeName
    rparEnablePreviewDotOps = "DotLikeOps"
    # warnings END !! add reports BEFORE the last enum !!


    #-----------------------------  VM reports  ------------------------------#
    # VM
    rvmOpcParseExpectedExpression
    rvmTooManyRegistersRequired
    rvmMissingImportcCompleteStruct
    rvmNotUnused
    rvmUserError
    rvmTooLargetOffset
    rvmUnhandledException
    rvmCannotGenerateCode
    rvmCannotCast
    rvmCannotEvaluateAtComptime
    rvmCannotImportc
    rvmCannotCallMethod
    rvmCannotModifyTypechecked
    rvmNilAccess
    rvmAccessOutOfBounds
    rvmAccessTypeMismatch
    rvmAccessNoLocation
    rvmErrInternal
    rvmIndexError
    rvmOutOfRange
    rvmOverOrUnderflow
    rvmDivisionByConstZero
    rvmNodeNotASymbol
    rvmNodeNotAProcSymbol
    rvmIllegalConv
    rvmIllegalConvFromXToY
    rvmMissingCacheKey
    rvmCacheKeyAlreadyExists
    rvmFieldNotFound
    rvmFieldInavailable
    rvmCannotCreateNode
    rvmCannotSetChild
    rvmCannotAddChild
    rvmCannotGetChild
    rvmNoType
    rvmNotAField
    rvmUnsupportedNonNil
    rvmQuit

    rvmTooManyIterations

    # trace
    rvmStackTrace
    # trace


    #-----------------------------  Sem reports  -----------------------------#
    # semantic fatal
    rsemFatalError
    # end

    # Semantic errors begin
    rsemUserError = "UserError" ## `{.error: }`
    rsemUsageIsError

    rsemCompilesHasSideEffects ## lightweight to avoid heavy diagnostic
                               ## querying for compiles context

    rsemCustomError
    rsemCustomPrintMsgAndNodeError
      ## just like custom error, prints a message and renders wrongNode
    rsemTypeMismatch
    rsemTypeKindMismatch
    rsemAmbiguous
    rsemAmbiguousIdentWithCandidates
    rsemAmbiguousIdent

    rsemCustomUserError
      ## just like customer error, but reported as a errUser in msgs

    rsemNodeNotAllowed
      ## Generated in `filters.nim`
      ## TODO: this is not a sem error, it's a source filters error

    rsemCannotProveNotNil
    rsemProvablyNil

    # nimsuggest
    rsemSugNoSymbolAtPosition

    # Global Errors
    rsemCustomGlobalError
      ## just like custom error, but treat it like a "raise" and fast track the
      ## "graceful" abort of this compilation run, used by `errorreporting` to
      ## bridge into the existing `msgs.liMessage` and `msgs.handleError`.

    # Module errors
    rsemSystemNeeds
    rsemInvalidModulePath
    rsemInvalidModuleName
    rsemCannotImportItself
    rsemRecursiveInclude
    rsemCannotOpenFile
    rsemExportRequiresToplevel
    rsemExperimentalRequiresToplevel
    rsemMethodRequiresToplevel
    rsemPackageRequiresToplevel
    rsemConverterRequiresToplevel
    rsemImportRequiresToplevel
    rsemUnexpectedToplevelDefer
    rsemUsingRequiresToplevel
    rsemInvalidVisibility
    rsemUnknownPackageName
    rsemUnexpectedInfixInInclude

    # ..
    rsemConflictingExportnims
    rsemNoMagicEqualsForType
    rsemCantConvertLiteralToType
    rsemCantConvertLiteralToRange
    rsemCantComputeOffsetof
    rsemStaticOutOfBounds ## Error generated when semfold or static bound
    ## checking sees and out-of-bounds index error.
    rsemStaticFieldNotFound # TODO DOC generated in `semfold.nim`, need
    # better documentation, right now I don't know what exactly this error
    # means and how to reproduce it in the example code.
    rsemSemfoldOverflow
    rsemSemfoldDivByZero
    rsemInvalidIntdefine
    rsemInvalidBooldefine


    # Type definitions
    rsemCaseInUnion ## `{.union.}` type cannot use `case:` statements
    rsemOffsetInUnion ## `{.union.}` type cannot use inheritance and any
    ## other features that add implicit chunk of data before the actually
    ## listed fields.
    rsemUnexpectedInNewConcept
    rsemTooNestedConcept
    rsemIllegalRecursion
    rsemCannotInferStaticValue

    rsemVarVarNotAllowed ## `var lent`, `var var` etc. are not allowed in
    ## types
    rsemInvalidOrderInEnum
    rsemSetTooBig
    rsemTIsNotAConcreteType
    rsemProcIsNotAConcreteType
    rsemRangeIsEmpty
    rsemStringRangeNotAllowed

    rsemCannotInstantiate
    rsemCannotInstantiateWithParameter
    rsemCannotGenerateGenericDestructor
    rsemUndeclaredField
    rsemExpectedOrdinal
    rsemExpectedOrdinalOrFloat
    rsemExpectedUnholyEnum # yes
    rsemExpectedLow0Discriminant
    rsemExpectedHighCappedDiscriminant
    rsemMissingCaseBranches
    rsemRangeDoesNotSupportNan
    rsemRangeRequiresDotDot
    rsemExpectedRange
    rsemArrayExpectsPositiveRange
    rsemExpectObjectForBase
    rsemExpectNonFinalForBase

    rsemTVoidNotAllowed
    rsemExpectedObjectForRegion
    rsemUnexpectedVoidType
    rsemUnexpectedArrayAssignForCstring
    rsemMacroBodyDependsOnGenericTypes
    rsemMalformedNotNilType
    rsemEnableNotNilExperimental
    rsemEnableDotOperatorsExperimental
    rsemEnableCallOperatorExperimental
    rsemUnexpectedPattern
    rsemExpectedObjectType
    rsemExpectedImportedType
    rsemUnexpectedExportcInAlias
    rsemExpectedDistinctForBorrow
    rsemBorrowTargetNotFound
    rsemConceptInferenceFailed
    rsemConceptPredicateFailed

    # Procedure definition and instantiation
    rsemImplementationNotAllowed
    rsemImplementationExpected
    rsemRedefinitionOf
    rsemDefaultParamIsIncompatible
    rsemDeclarationVisibilityMismatch
    rsemGenericLambdaNowAllowed
    rsemUnexpectedAutoInForwardDeclaration
    rsemUnexpectedClosureOnToplevelProc
    rsemExpectedReturnTypeForIterator
    rsemExpectedReturnTypeForConverter
    rsemExpectedOneArgumentForConverter
    rsemIncompatibleDefaultExpr

    # Call and procedures
    rsemCallTypeMismatch
    rsemCallIndirectTypeMismatch
    rsemCallNotAProcOrField ## unknown or semantically invalid `obj.field`,
    ## `obj.call()`
    rsemExpressionCannotBeCalled
    rsemWrongNumberOfArguments
    rsemIsOperatorTakes2Args
    rsemWrongNumberOfVariables
    rsemWrongNumberOfGenericParams
    rsemNoGenericParamsAllowed
    rsemAmbiguousCall
    rsemCallingConventionMismatch
    rsemHasSideEffects
    rsemCantPassProcvar
    rsemHookCannotRaise
    rsemUnlistedRaises
    rsemUnlistedEffects
    rsemOverrideSafetyMismatch
    rsemOverrideLockMismatch
    rsemMissingMethodDispatcher
    rsemNotABaseMethod
    rsemIllegalCallconvCapture
    rsemIllegalMemoryCapture
    rsemIllegalCompTimeCapture
    rsemIgnoreInvalidForLoop
    rsemMissingGenericParamsForTemplate
    rsemMisplacedMagicType
    rsemCannotInferParameterType
    rsemParameterRequiresAType
    rsemParameterRedefinition
    rsemInvalidExpression
    rsemExpectedNonemptyPattern

    rsemTemplateInstantiationTooNested
    rsemMacroInstantiationTooNested
    rsemGenericInstantiationTooNested # TODO write out list of generic,
    # macro or template instantiations. There is a `pushOwner` called for
    # each generic instantiation - can this be reused?

    rsemInvalidMethodDeclarationOrder # Right now I have no idea what this
    # error means exactly. It /does/ have a 'sort of' reproducible example
    # - https://github.com/nim-lang/Nim/issues/5325. No real tests for this
    # one of course, I mean who needs this, right?
    rsemParameterNotPointerToPartial

    # Statements
    rsemDiscardingVoid
    rsemDiscardingProc
    rsemInvalidControlFlow
    rsemExpectedLabel
    rsemContinueCannotHaveLabel
    rsemUseOrDiscard
    rsemUseOrDiscardExpr
    rsemCannotBeRaised
    rsemCannotRaiseNonException
    rsemExceptionAlreadyHandled
    rsemCannotExceptNativeAndImported
    rsemExpectedSingleFinally
    rsemExpectedSingleGeneralExcept
    rsemCannotConvertToRange
    rsemUsingRequiresType
    rsemUsingDisallowsAssign
    rsemDifferentTypeForReintroducedSymbol
    rsemCannotInferTypeOfLiteral
    rsemCannotInferTypeOfParameter
    rsemProcHasNoConcreteType
    rsemThreadvarCannotInit
    rsemLetNeedsInit
    rsemConstExpressionExpected
    rsemFieldsIteratorCannotContinue
    rsemParallelFieldsDisallowsCase
    rsemNoObjectOrTupleType
    rsemForExpectsIterator
    rsemSelectorMustBeOfCertainTypes
    rsemTypeCannotBeForwarded
    rsemDoubleCompletionOf
    rsemExpectedInvariantParam
    rsemCovariantUsedAsNonCovariant
    rsemContravariantUsedAsNonCovariant
    rsemNonInvariantCannotBeUsedWith
    rsemNonInvariantCnnnotBeUsedInConcepts
    rsemIncorrectResultProcSymbol
    rsemRebidingImplicitDestructor
    rsemRebidingDestructor
    rsemRebidingDeepCopy
    rsemInseparableTypeBoundOp
    rsemUnexpectedTypeBoundOpSignature
    rsemExpectedDestroyOrDeepCopyForOverride
    rsemExpectedObjectForMethod
    rsemUnexpectedPragmaInDefinitionOf
    rsemMisplacedRunnableExample
    rsemCannotReraise

    # Expressions
    rsemConstantOfTypeHasNoValue
    rsemTypeConversionArgumentMismatch
    rsemUnexpectedEqInObjectConstructor
    rsemIllegalConversion
    rsemCannotBeConvertedTo
    rsemCannotCastToNonConcrete
    rsemCannotCastTypes
    rsemExpectedTypeOrValue
    rsemInvalidArgumentFor
    rsemNoTupleTypeForConstructor
    rsemInvalidTupleConstructor
    rsemUnknownIdentifier
    rsemIndexOutOfBounds
    rsemInvalidOrderInArrayConstructor
    rsemVarForOutParamNeeded
    rsemStackEscape
    rsemExprHasNoAddress
    rsemUnknownTrait
    rsemStringOrIdentNodeExpected
    rsemExpectedObjectForOf
    rsemCannotBeOfSubtype
    rsemQuantifierInRangeExpected
    rsemOldTakesParameterName
    rsemOldDoesNotBelongTo
    rsemCannotFindPlugin
    rsemCannotIsolate
    rsemRecursiveDependencyIterator
    rsemIllegalNimvmContext
    rsemDisallowedNilDeref
    rsemCannotDeref
    rsemInvalidTupleSubscript
    rsemLocalEscapesStackFrame
    rsemImplicitAddrIsNotFirstParam
    rsemCannotAssignTo
    rsemNoReturnTypeDeclared
    rsemReturnNotAllowed
    rsemIllegalCompileTimeAccess
    rsemCannotInferReturnType
    rsemExpectedValueForYield
    rsemUnexpectedYield
    rsemYieldExpectedTupleConstr
      ## a literal tuple constructor is required when the iterator returns a
      ## tuple containing a view
    rsemCannotReturnTypeless
    rsemExpectedMacroOrTemplate
    rsemAmbiguousGetAst
    rsemExpectedTemplateWithNArgs
    rsemExpectedCallForGetAst
    rsemWrongNumberOfQuoteArguments
    rsemNamedExprExpected
    rsemNamedExprNotAllowed
    rsemFieldInitTwice
    rsemDisallowedTypedescForTupleField
    rsemDisjointFields
    rsemUnsafeRuntimeDiscriminantInit
    rsemConflictingDiscriminantInit
    rsemConflictingDiscriminantValues
    rsemRuntimeDiscriminantInitCap
    rsemRuntimeDiscriminantMustBeImmutable
    rsemRuntimeDiscriminantRequiresElif
    rsemObjectRequiresFieldInit
    rsemObjectRequiresFieldInitNoDefault
    rsemObjectDoesNotHaveDefaultValue
    rsemDistinctDoesNotHaveDefaultValue
    rsemExpectedModuleNameForImportExcept
    rsemCannotExport
    rsemCannotMixTypesAndValuesInTuple
    rsemInvalidBindContext
    rsemCannotCreateImplicitOpenarray
    rsemCannotAssignToDiscriminantWithCustomDestructor
    rsemUnavailableTypeBound
    rsemUnavailableLocation

    # Identifier Lookup
    rsemUndeclaredIdentifier
    rsemExpectedIdentifier
    rsemExpectedIdentifierQuoteLimit
    rsemExpectedIdentifierInExpr
    rsemExpectedIdentifierWithExprContext
    rsemModuleAliasMustBeIdentifier
    rsemOnlyDeclaredIdentifierFoundIsError

    # Object and Object Construction
    rsemFieldNotAccessible
      ## object field is not accessible
    rsemFieldAssignmentInvalid
      ## object field assignment invalid syntax
    rsemFieldAssignmentInvalidNeedSpace
      ## object field assignment invalid syntax, need space after colon

    # General Type Checks
    rsemExpressionHasNoType
      ## an expression has not type or is ambiguous

    rsemRawTypeMismatch

    rsemCannotConvertTypes
    rsemCannotCreateFlowVarOfType
    rsemTypeNotAllowed

    # Literals
    rsemIntLiteralExpected
      ## int literal node was expected, but got something else
    rsemStringLiteralExpected
      ## string literal node was expected, but got something else

    rsemOnOrOffExpected
    rsemCallconvExpected
    rsemUnknownExperimental
    rsemDuplicateCaseLabel

    # view types
    rsemExpressionIsNotAPath
    rsemResultMustBorrowFirst
    rsemCannotDetermineBorrowTarget # TODO DOC need better explanation for
    # reasons of this error, right now it looks like a hacked-in check.
    rsemCannotBorrow
    rsemBorrowOutlivesSource
    rsemImmutableBorrowMutation

    rsemCyclicTree
    rsemCyclicDependency
    rsemConstExprExpected

    # Codegen
    rsemRttiRequestForIncompleteObject
    rsemExpectedNimcallProc
    rsemExpectedParameterForJsPattern
    rsemRequiresDeepCopyEnabled
    rsemDisallowedOfForPureObjects
    rsemCannotCodegenCompiletimeProc

    # Pragma
    rsemInvalidPragma
      ## suplied pragma is invalid
    rsemUnexpectedPragma
    rsemPropositionExpected
    rsemIllegalCustomPragma
      ## supplied pragma is not a legal custom pragma, and cannot be attached
    rsemExternalLocalNotAllowed
      ## a local is specified to be part of an external interface
    rsemNoReturnHasReturn
      ## a routine marked as no return, has a return type
    rsemImplicitPragmaError
      ## a symbol encountered an error when processing implicit pragmas, this
      ## should be applied to symbols and treated as a wrapper for the purposes
      ## of reporting. the original symbol is stored as the first argument
    rsemPragmaDynlibRequiresExportc
      ## much the same as `ImplicitPragmaError`, except it's a special case
      ## where dynlib pragma requires an importc pragma to exist on the same
      ## symbol
      ## xxx: pragmas shouldn't require each other, that's just bad design

    rsemWrappedError
      ## there is no meaningful error to construct, but there is an error
      ## further down the AST that invalidates the whole

    rsemPragmaDisallowedForTupleUnpacking
      ## we disallow pragma blocks `let (foo {.somePragma.}, bar) = (1,2)` as
      ## the semantics of pragmas in the face of unpacking are not woefully
      ## underspecified. This is not a matter of reenabling it as a rethinking
      ## the approach from a first principles perspective is required.

    rsemIllegalCompileTime
      ## when used on variables, the ``.compileTime`` pragma must only be
      ## applied to locals inside compile-time procedures or to globals

    rsemSymbolKindMismatch
    rsemIllformedAst
    rsemInitHereNotAllowed
    rsemTypeExpected
    rsemSinkIsNotATypeClass
    rsemGenericTypeExpected
    rsemTypeInvalid
    rsemWrongIdent
    rsemPragmaOptionExpected
    rsemUnexpectedPushArgument
    rsemCannotPushCast
    rsemCastRequiresStatement
    rsemDynlibRequiresExportc
    rsemImportjsRequiresJs
    rsemBitsizeRequires1248
    rsemBitsizeRequiresPositive
    rsemAlignRequiresPowerOfTwo
    rsemPragmaRecursiveDependency
    rsemMisplacedDeprecation
    rsemNoUnionForJs

    rsemThisPragmaRequires01Args
    rsemMismatchedPopPush
    rsemExcessiveCompilePragmaArgs
    rsemLinePragmaExpectsTuple
    rsemRaisesPragmaExpectsObject

    rsemCompilerOptionInvalid
    rsemCompilerOptionArgInvalid

    # -- locking
    rsemLocksPragmaExpectsList
    rsemLocksPragmaBadLevel
    rsemLocksRequiresArgs
    rsemMultilockRequiresSameLevel
    rsemInvalidNestedLocking
    rsemUnguardedAccess
    rsemInvalidGuardField

    rsemStaticIndexLeqUnprovable
    rsemStaticIndexGeProvable

    rsemErrGcUnsafeListing
    rsemBorrowPragmaNonDot
    rsemInvalidExtern
    rsemInvalidPragmaBlock
    rsemMisplacedEffectsOf
    rsemMissingPragmaArg
    rsemErrGcUnsafe
    rsemEmptyAsm
    # END !! add reports BEFORE the last enum !!

    # Semantic warnings begin
    rsemUserWarning              = "User" ## `{.warning: }`
    rsemUnknownMagic             = "UnknownMagic"
    rsemUnusedImport             = "UnusedImport"
    rsemDeprecated               = "Deprecated"
    rsemDeprecatedCompilerOpt    = "Deprecated"
    rsemDeprecatedCompilerOptArg = "Deprecated"
    rsemLockLevelMismatch        = "LockLevel"
    rsemTypelessParam            = "TypelessParam"
    rsemOwnedTypeDeprecated
    rsemCodegenDeclDeprecated    = "Deprecated"

    rsemWarnUnlistedRaises = "Effect" ## `sempass2.checkRaisesSpec` had
    ## `emitWarnings: bool` parameter which was supposedly used to control
    ## whether `strictEffects` warnings actually generated an error, or
    ## just a warning. But all four uses of this proc had constant `false`
    ## written to this field, so for now it does not mean anything and all
    ## mismatched raises are routed as errors.

    rsemDotForModuleImport
    rsemProveField             = "ProveField"
    rsemStrictNotNilExpr       = "StrictNotNil"
    rsemStrictNotNilResult     = "StrictNotNil"
    rsemWarnGcUnsafe           = "GcUnsafe"
    rsemWarnGcUnsafeListing    = "GcUnsafe2"
    rsemProveInit              = "ProveInit"
    rsemUninit                 = "Uninit"
    rsemImplicitCstringConvert = "CStringConv"
    rsemHoleEnumConvert        = "HoleEnumConv"
    rsemAnyEnumConvert         = "AnyEnumConv"
    rsemMethodLockMismatch
    rsemUseBase                = "UseBase"
    rsemUnreachableElse        = "UnreachableElse"
    rsemUnreachableCode        = "UnreachableCode"
    rsemInheritFromException   = "InheritFromException"
    rsemPtrRegionIsDeprecated
    rsemTypedReturnDeprecated
    rsemEachIdentIsTuple       = "EachIdentIsTuple"
    rsemResultShadowed         = "ResultShadowed"
    rsemResultUsed             = "ResultUsed"
    rsemGenericMethodsDeprecated
    rsemSuspiciousEnumConv     = "EnumConv"
    rsemUnsafeSetLen           = "UnsafeSetLen"
    rsemUnsafeDefault          = "UnsafeDefault"
    rsemUntypedParamsFollwedByMoreSpecificType
    rsemBindDeprecated
    rsemObservableStores       = "ObservableStores"
    rsemUnknownHint            = "UnknownHint"
    rsemUnknownWarning         = "UnknownWarning"
    rsemUseOfGc                = "GcMem" # last !
    # END !! add reports BEFORE the last enum !!


    # Semantic hints begin
    rsemUserHint = "User" ## `{.hint: .}` pragma encountereed
    rsemLinterReport  = "Name"
    rsemLinterReportUse = "Name"
    rsemHintLibDependency = "Dependency"
    rsemXDeclaredButNotUsed = "XDeclaredButNotUsed"
    rsemDuplicateModuleImport = "DuplicateModuleImport"
    rsemXCannotRaiseY = "XCannotRaiseY"
    rsemConvToBaseNotNeeded = "ConvToBaseNotNeeded"
    rsemConvFromXtoItselfNotNeeded = "ConvFromXtoItselfNotNeeded"
    rsemClosureWithoutEnv          = "ClosureWithoutEnv"

    rsemProcessing = "Processing" ## Processing module
    rsemProcessingStmt = "ProcessingStmt" ## Processing toplevel statement

    rsemExprAlwaysX = "ExprAlwaysX" ## Expression always evaluates to "X"
    rsemConditionAlwaysTrue = "CondTrue" ## Condition is always true
    rsemConditionAlwaysFalse = "CondFalse" ## Condition is always false

    rsemPattern = "Pattern" ## Term rewriting pattern has been triggered
    rsemCannotMakeSink ## Argument could not be turned into a sink
                       ## parameter. Generated once in the whole compiler
                       ## `sinkparameter_inference.nim`
    rsemCopiesToSink ## Passing data to the `sink` parameter still copies
                     ## due to control flow in the code

    rsemGlobalVar = "GlobalVar" ## Track global variable declarations?

    rsemEffectsListingHint
    rsemExpandMacro = "ExpandMacro" ## Trace macro expansion progress

    rsemCompilesReport
    rsemNonMatchingCandidates

    rsemExtendedContext = "ExtendedContext" ## Extended contextual
    ## information. Used in `ccgstmts.genStmts()` and
    ## `semexprs.semExprNoType()`
    rsemDiagnostics
    rsemImplicitObjConv = "ImplicitObjConv"
    # END !! add reports BEFORE the last enum !!


    #------------------------  Command report kinds  -------------------------#
    # errors
    rcmdFailedExecution
    # errors end

    # hints
    rcmdCompiling = "CC"
    rcmdLinking = "Link"
    rcmdExecuting = "Exec"
    rcmdRunnableExamplesSuccess = "Success"
    # hints END !! add reports BEFORE the last enum !!

    #----------------------------  Debug reports  ----------------------------#
    rdbgVmExecTraceFull
    rdbgVmExecTraceMinimal

    rdbgOptionsPush
    rdbgOptionsPop

    #---------------------------  Backend reports  ---------------------------#
    # errors start
    rbackCannotWriteScript ## Cannot write build script to a cache file
    rbackCannotWriteMappingFile ## Cannot write module compilation mapping
    ## file to cache directory
    rbackTargetNotSupported ## C compiler does not support requested target
    rbackJsTooCaseTooLarge
    rbackJsonScriptMismatch # ??? used in `extccomp.nim`, TODO figure out
    # what the original mesage was responsible for exactly

    rbackVmFileWriteFailed

    rbackRstCannotOpenFile
    rbackRstExpected
    rbackRstGridTableNotImplemented
    rbackRstMarkdownIllformedTable
    rbackRstNewSectionExpected
    rbackRstGeneralParseError
    rbackRstInvalidDirective
    rbackRstInvalidField
    rbackRstFootnoteMismatch

    rbackCannotProduceAssembly
    # errors END !! add reports BEFORE the last enum !!

    # warnings start
    rbackRstTestUnsupported
    rbackRstRedefinitionOfLabel = "RedefinitionOfLabel"
    rbackRstUnknownSubstitution = "UnknownSubstitutionX"
    rbackRstBrokenLink          = "BrokenLink"
    rbackRstUnsupportedLanguage = "LanguageXNotSupported"
    rbackRstUnsupportedField    = "FieldXNotSupported"
    rbackRstRstStyle            =  "warnRstStyle"

    # warnings END !! add reports BEFORE the last enum !!

    # hints start
    rbackProducedAssembly
    rbackCompiling = "Compiling"
    rbackLinking = "Link"
    # hints END !! add reports BEFORE the last enum !!

  ReportKinds* = set[ReportKind]


const rstWarnings* = {rbackRstTestUnsupported .. rbackRstRstStyle}

type
  LexerReportKind* = range[
    rlexMalformedNumUnderscores .. rlexSourceCodeFilterOutput]

  ParserReportKind* = range[rparInvalidIndentation .. rparEnablePreviewDotOps]
  VMReportKind* = range[rvmOpcParseExpectedExpression .. rvmStackTrace]
  SemReportKind* = range[rsemFatalError .. rsemImplicitObjConv]
  SemOrVMReportKind* = range[low(VMReportKind) .. high(SemReportKind)]

  SemReportErrorKind* = range[rsemUserError .. rsemWrappedError]

  CmdReportKind* = range[rcmdFailedExecution .. rcmdRunnableExamplesSuccess]

  DebugReportKind* = range[rdbgVmExecTraceFull .. rdbgOptionsPop]

  BackendReportKind* = range[rbackCannotWriteScript .. rbackLinking]

  ExternalReportKind* = range[rextCmdRequiresFile .. rextPath]

  InternalReportKind* = range[rintUnreachable .. rintEchoMessage]


const
  #--------------------------------  lexer  --------------------------------#
  repLexerKinds*    = {low(LexerReportKind) .. high(LexerReportKind)}
  rlexHintKinds*    = {rlexLineTooLong .. rlexSourceCodeFilterOutput}
  rlexWarningKinds* = {rlexDeprecatedOctalPrefix .. rlexDeprecatedOctalPrefix}
  rlexErrorKinds*   = {rlexMalformedNumUnderscores .. rlexUnclosedComment}


  #-------------------------------  parser  --------------------------------#
  repParserKinds* = {low(ParserReportKind) .. high(ParserReportKind)}
  rparHintKinds*    = {}
  rparErrorKinds*   = {rparInvalidIndentation .. rparInvalidFilter}
  rparWarningKinds* = {
    rparInconsistentSpacing .. rparEnablePreviewDotOps}

  #---------------------------------  vm  ---------------------------------#
  repVMKinds* = {low(VMReportKind) .. high(VMReportKind)}
  rvmHintKinds* = default(set[ReportKind])
  rvmTraceKinds* = {rvmStackTrace}
  rvmWarningKinds* = default(set[ReportKind])
  rvmErrorKinds* = repVMKinds - rvmTraceKinds

  #---------------------------------  sem  ---------------------------------#
  repSemKinds* = {low(SemReportKind) .. high(SemReportKind)}
  rsemErrorKinds* = {rsemUserError .. rsemEmptyAsm}
  rsemWarningKinds* = {rsemUserWarning .. rsemUseOfGc}
  rsemHintKinds* = {rsemUserHint .. rsemImplicitObjConv}

  # Separated into standalone set to reuse in the `options.severity`
  # checking - `--styleCheck=error` is set up as a global option.
  repLinterKinds* = {rlexLinterReport, rsemLinterReport, rsemLinterReportUse}

  # `--experimental=strictNotNil` and `{.experimental: "strictNotNil".}`
  repNilcheckKinds* = {rsemStrictNotNilExpr, rsemStrictNotNilResult}

  #---------------------------------  cmd  ---------------------------------#
  repCmdKinds* = {low(CmdReportKind) .. high(CmdReportKind)}
  rcmdErrorKinds* = {rcmdFailedExecution}
  rcmdWarningKinds* = default(set[ReportKind])
  rcmdHintKinds* = {rcmdCompiling .. rcmdRunnableExamplesSuccess}

  #--------------------------------  debug  --------------------------------#
  repDebugKinds* = {low(DebugReportKind) .. high(DebugReportKind)}

  #-------------------------------  backend  -------------------------------#
  repBackendKinds* = {low(BackendReportKind) .. high(BackendReportKind)}
  rbackErrorKinds* = {rbackCannotWriteScript .. rbackCannotProduceAssembly}
  rbackWarningKinds* = {rbackRstTestUnsupported .. rbackRstRstStyle}
  rbackHintKinds* = {rbackProducedAssembly .. rbackLinking}

  #------------------------------  external  -------------------------------#
  repExternalKinds* = {low(ExternalReportKind) .. high(ExternalReportKind)}
  rextErrorKinds* = {rextCmdRequiresFile .. rextCmdRequiresFile}
  rextHintKinds* = {rextConf .. rextPath}


  #------------------------------  internal  -------------------------------#
  repInternalKinds*: ReportKinds = {
    low(InternalReportKind) .. high(InternalReportKind)}

  rintFatalKinds* = {rintUnreachable .. rintAssert} ## Fatal internal compilation
                                                ## reports
  rintErrorKinds* = {rintCannotOpenFile .. rintNotImplemented}
  rintWarningKinds* = {rintWarnCannotOpenFile .. rintWarnFileChanged}
  rintHintKinds* = {rintSource .. rintSuccessX}
  rintDataPassKinds* = {rintStackTrace .. rintEchoMessage}


const
  repWarningKinds*: ReportKinds =
    rsemWarningKinds +
      rlexWarningKinds +
      rparWarningKinds +
      rbackWarningKinds +
      rvmWarningKinds +
      rcmdWarningKinds +
      rintWarningKinds

  repTraceKinds*: ReportKinds =
    {rvmStackTrace, rintStackTrace} +
    repDebugKinds

  repHintKinds*: ReportKinds    =
    rsemHintKinds +
      rlexHintKinds +
      rparHintKinds +
      rbackHintKinds +
      rvmHintKinds +
      rextHintKinds +
      rcmdHintKinds +
      rintHintKinds

  repErrorKinds*: ReportKinds   =
    rsemErrorKinds +
      rlexErrorKinds +
      rparErrorKinds +
      rbackErrorKinds +
      rvmErrorKinds +
      rextErrorKinds +
      rcmdErrorKinds +
      rintErrorKinds

  repDataPassKinds*: ReportKinds =
    rintDataPassKinds

  repFatalKinds*: ReportKinds = rintFatalKinds + {rsemFatalError}
  repAllKinds* = {low(ReportKind) .. high(ReportKind)}

static:
  block:
    let diff = repAllKinds - (
      repWarningKinds +
      repHintKinds +
      repTraceKinds +
      repErrorKinds +
      repDataPassKinds +
      repFatalKinds +
      { repNone }
    )

    assert(
      len(diff) == 0,
      "Severity grouping is missing some elements: " & $diff
    )

  block:
    let diff = repAllKinds - (
      set[ReportKind](repVMKinds) +
      set[ReportKind](repSemKinds) +
      set[ReportKind](repLexerKinds) +
      set[ReportKind](repParserKinds) +
      set[ReportKind](repInternalKinds) +
      set[ReportKind](repExternalKinds) +
      set[ReportKind](repDebugKinds) +
      set[ReportKind](repBackendKinds) +
      set[ReportKind](repCmdKinds) +
      { repNone }
    )

    assert(
      len(diff) == 0,
      "Report ranges are missing some elements: " & $diff
    )

const
  rsemReportTwoSym* = {
    rsemConflictingExportnims,
    rsemBorrowOutlivesSource,
    rsemImmutableBorrowMutation,
    rsemRedefinitionOf,
    rsemInvalidMethodDeclarationOrder, # [s, witness]
    rsemIllegalCallconvCapture, # [symbol, owner]
    rsemDeprecated # [symbol, use-instead]
  }

  rsemReportOneSym* = {
    rsemUnexpectedPragmaInDefinitionOf,
    rsemDoubleCompletionOf,

    rsemOverrideSafetyMismatch,
    rsemOverrideLockMismatch
  }

  rsemReportListSym* = {
    rsemAmbiguous,
    rsemAmbiguousIdentWithCandidates,
    rsemObjectRequiresFieldInit,
    rsemObjectRequiresFieldInitNoDefault
  }

  rsemReportCountMismatch* = {
    rsemWrongNumberOfArguments,
    rsemWrongNumberOfGenericParams,
    # rsemExpectedLow0Discriminant,     # xxx: we don't report the numbers
    rsemInvalidOrderInArrayConstructor,
    rsemTypeConversionArgumentMismatch,
    rsemInvalidTupleSubscript,
    rsemExpectedTemplateWithNArgs,
    rsemWrongNumberOfQuoteArguments,
    rsemIndexOutOfBounds,
    # rsemExpectedHighCappedDiscriminant
  }

  rsemReportBigOrdsEnergy* = { ## My Big Ords need some Big Ints
    rsemSetTooBig,
    rsemArrayExpectsPositiveRange,
    rsemInvalidOrderInEnum
  }

  repPerformanceHints* = {
    rsemCopiesToSink,
    rsemCannotMakeSink
  }

  repLinkingHints* = {
    rbackLinking,
    rcmdLinking
  }

  repStrictNotNilWarnings* = {
    rsemStrictNotNilExpr,
    rsemStrictNotNilResult
  }



const
  repHintGroups* = @{
    "all": repHintKinds,
    "Performance": repPerformanceHints,
    "Name": repLinterKinds,
    "Link": repLinkingHints,
  }

  repWarningGroups* = @{
    "all": repWarningKinds,
    "StrictNotNil": repStrictNotNilWarnings
  }
