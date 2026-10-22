package com.gc.gameshop;

import static org.junit.jupiter.api.Assertions.*;

import java.nio.file.*;
import org.junit.jupiter.api.Test;

class LayerBoundaryTest {
  private final Path source = Path.of("src/main/java/com/gc/gameshop");

  @Test
  void controllersNeverUseSqlOrPersistenceTypes() throws Exception {
    try (var paths = Files.walk(source.resolve("controller"))) {
      for (Path path : paths.filter(p -> p.toString().endsWith(".java")).toList()) {
        String code = Files.readString(path);
        assertFalse(code.contains("gameshop.mapper"), path.toString());
        assertFalse(code.contains("gameshop.persistence"), path.toString());
      }
    }
  }

  @Test
  void servicesNeverDependOnWebInputOrWebOutput() throws Exception {
    try (var paths = Files.walk(source.resolve("service"))) {
      for (Path path : paths.filter(p -> p.toString().endsWith(".java")).toList()) {
        String code = Files.readString(path);
        assertFalse(code.contains("gameshop.model.dto"), path.toString());
        assertFalse(code.contains("gameshop.model.vo"), path.toString());
        assertFalse(code.contains("HttpServletRequest"), path.toString());
      }
    }
  }

  @Test
  void mapperSqlNeverAcceptsRawSqlSubstitution() throws Exception {
    try (var paths = Files.walk(Path.of("src/main/resources/mapper/gameshop"))) {
      for (Path path : paths.filter(p -> p.toString().endsWith(".xml")).toList()) {
        assertFalse(Files.readString(path).contains("${"), path.toString());
      }
    }
  }
}
