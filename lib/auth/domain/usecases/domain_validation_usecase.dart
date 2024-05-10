class DomainValidationUseCase {
  bool call(String email) {
    return email.endsWith('@g.yju.ac.kr');
  }
}
