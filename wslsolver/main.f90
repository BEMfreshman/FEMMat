PROGRAM MUMPS_TEST
    IMPLICIT NONE
    INCLUDE 'mpif.h'
    INCLUDE 'dmumps_struc.h'
    TYPE (DMUMPS_STRUC) mumps_par
    INTEGER IERR, I
    INTEGER ILOGFN, IMATFN, IRSTFN
    INTEGER(8) I8, IR8, NNZ8
    DOUBLE PRECISION VAL
    LOGICAL THERE

    CALL MPI_INIT(IERR)
! Define a communicator for the package.
    mumps_par%COMM = MPI_COMM_WORLD
!  Initialize an instance of the package
!  for L U factorization (sym = 0, with working host)
    mumps_par%JOB = -1
    mumps_par%SYM = 0
    mumps_par%PAR = 1
    CALL DMUMPS(mumps_par)

    IF (mumps_par%MYID .eq. 0) THEN
        ILOGFN = 1
        OPEN(UNIT=ILOGFN,FILE='solver.log')
    ENDIF

    IF (mumps_par%INFOG(1).LT.0) THEN
        IF (mumps_par%MYID .eq. 0) THEN
            WRITE(ILOGFN,'(A,A,I6,A,I9)') "JOB -1 ERROR RETURN: ",              &
                    "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1),  &
                    "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2)
            GOTO 500
        END IF
    END IF


!  Define problem on the host (processor 0)
    IF ( mumps_par%MYID .eq. 0 ) THEN
        IMATFN = 2
        OPEN(UNIT=IMATFN,FILE='mat.txt')
        READ(IMATFN,*) mumps_par%N
        READ(IMATFN,*) mumps_par%NNZ
        ALLOCATE( mumps_par%IRN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%JCN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%A( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%RHS ( mumps_par%N  ) )

        DO I8 = 1, mumps_par%NNZ
            READ(IMATFN,*) mumps_par%IRN(I8),mumps_par%JCN(I8),mumps_par%A(I8)
        END DO

        DO I8 = 1, mumps_par%N
            mumps_par%RHS(I8) = 0.0
        END DO

        READ(IMATFN,*) NNZ8

        DO I8 = 1, NNZ8
            READ(IMATFN,*) IR8,VAL
            mumps_par%RHS(IR8) = VAL
        END DO
        CLOSE(IMATFN)
    END IF
!  Call package for solution
    mumps_par%ICNTL(24) = 1
    mumps_par%JOB = 6
    CALL DMUMPS(mumps_par)
    IF (mumps_par%INFOG(1).LT.0) THEN
        IF (mumps_par%MYID .eq. 0) THEN
            WRITE(ILOGFN,'(A,A,I6,A,I9)') "JOB 6 ERROR RETURN: ",  &
               "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1),  &
               "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2)
            
            INQUIRE(FILE='rst.txt', EXIST=THERE)
            IF (THERE) THEN
                IRSTFN = 3
                OPEN(UNIT=IRSTFN,FILE='rst.txt',STATUS='old')
                CLOSE(IRSTFN,STATUS='delete')
            ENDIF
            GOTO 500
        ENDIF
    END IF
!  Solution has been assembled on the host
    IF ( mumps_par%MYID .eq. 0 ) THEN
        IRSTFN = 3
        OPEN(UNIT=IRSTFN,FILE='rst.txt')
        DO I8 = 1, mumps_par%N
            WRITE( IRSTFN, '(E12.5)' ) mumps_par%RHS(I8)
        ENDDO
        CLOSE(IRSTFN)
    END IF
!  Deallocate user data
    IF ( mumps_par%MYID .eq. 0 )THEN
      DEALLOCATE( mumps_par%IRN )
      DEALLOCATE( mumps_par%JCN )
      DEALLOCATE( mumps_par%A   )
      DEALLOCATE( mumps_par%RHS )
    END IF
!  Destroy the instance (deallocate internal data structures)
    mumps_par%JOB = -2
    CALL DMUMPS(mumps_par)
    IF (mumps_par%INFOG(1).LT.0) THEN
        IF (mumps_par%MYID .eq. 0) THEN
            WRITE(ILOGFN,'(A,A,I6,A,I9)') " JOB -2 ERROR RETURN: ",             &
               "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), &
               "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2)  
            GOTO 500
        ENDIF
    END IF


500 CONTINUE
    IF (mumps_par%MYID .eq. 0) THEN
        CLOSE(ILOGFN)
    ENDIF

    CALL MPI_FINALIZE(IERR)
    STOP
    END