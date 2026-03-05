package shopping.member.api;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import shopping.member.domain.MemberRole;
import shopping.member.domain.MemberStatus;

public record RegisterRequest(
        @NotBlank @Email String email,
        @NotBlank @Size(min = 8, max = 64) String password,
        MemberStatus status,
        MemberRole role
) {
}
