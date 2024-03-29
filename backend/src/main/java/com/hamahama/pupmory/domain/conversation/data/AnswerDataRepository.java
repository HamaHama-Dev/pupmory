package com.hamahama.pupmory.domain.conversation.data;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

public interface AnswerDataRepository extends JpaRepository<AnswerData, LineDataId> {
    @Query(value = "SELECT * FROM answer_data WHERE stage = :stage AND set = :set AND line_id = :id AND selection = :selection ;", nativeQuery = true)
    AnswerData findSelectTypeAnswer(@Param("stage") Long stage, @Param("set") Long set, @Param("id") Long lineId, @Param("selection") Long selection);

    @Query(value = "SELECT * FROM answer_data WHERE stage = :stage AND set = :set AND line_id = :id ;", nativeQuery = true)
    AnswerData findOtherTypeAnswer(@Param("stage") Long stage, @Param("set") Long set, @Param("id") Long lineId);
}
