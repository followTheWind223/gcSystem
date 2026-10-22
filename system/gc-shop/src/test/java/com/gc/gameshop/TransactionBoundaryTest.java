package com.gc.gameshop;

import static org.junit.jupiter.api.Assertions.*;

import com.gc.gameshop.service.impl.OrderServiceImpl;
import java.util.Set;
import org.junit.jupiter.api.Test;
import org.springframework.transaction.annotation.Transactional;

class TransactionBoundaryTest {
  @Test
  void allTradingMutationsDeclareAServiceTransaction() {
    Set<String> mutations =
        Set.of("create", "cancel", "pay", "adminCancel", "complete", "expire", "adjust");
    for (var method : OrderServiceImpl.class.getDeclaredMethods()) {
      if (mutations.contains(method.getName())) {
        assertNotNull(method.getAnnotation(Transactional.class), method.getName());
      }
    }
  }
}
