# ── Build stage ──────────────────────────────────────────────────────────────
# Kept here for reference; in the pipeline Maven runs on the Actions runner
# so we copy the pre-built JAR in the runtime stage below.
# ─────────────────────────────────────────────────────────────────────────────

# ── Runtime stage ─────────────────────────────────────────────────────────────
# eclipse-temurin:17-jre is the recommended OpenJDK base maintained by Adoptium.
# Using the -jre variant (not -jdk) minimises attack surface.
FROM eclipse-temurin:17.0.1_12-jre-focal

# Run as a non-root user — required by many Kubernetes PodSecurityStandards.
RUN groupadd --gid 10001 appgroup \
 && useradd  --uid 10001 --gid appgroup --no-create-home appuser

WORKDIR /app

# Copy the fat JAR produced by Maven into the image.
COPY --chown=appuser:appgroup target/devsecops-demo-1.0.0.jar app.jar

USER appuser

# Expose documentation port (optional; adjust to match your app).
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
