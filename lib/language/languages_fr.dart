import 'languages.dart';

class LanguageFr extends BaseLanguage {
  /// Login Page
  @override
  String get log_text1 => 'Connexion';
  @override
  String get log_text2 => 'Courriel';
  @override
  String get log_text3 => 'Mot de Passe';

  /// Bottom Navigation Bar
  @override
  String get bn_text1 => "Page d'accueil";
  @override
  String get bn_text2 => 'Feuille de temps';
  @override
  String get bn_text3 => 'Commencer/Quitter';
  @override
  String get bn_text4 => 'Vacances';
  @override
  String get bn_text5 => "Demande d'outils";

  ///home
  @override
  String get home_text1 =>
      'Point de référence quotidien pour Service et Installation';
  @override
  String get home_text2 => 'Objectif quotidien ';
  @override
  String get home_text22 => '(Technicien)';
  @override
  String get home_text3 => 'Objectif quotidien de Service ';
  @override
  String get home_text33 => '(Technicien + Apprenti)';
  @override
  String get home_text4 => 'Objectif quotidien de Service ';
  @override
  String get home_text44 => '(Technicien + Apprenti)';
  @override
  String get home_text5 => 'Objectif quotidien d’Installation ';
  @override
  String get home_text55 => '(Technicien+Technicien)';
  @override
  String get home_text6 => 'Opportunité potentielle avec Electrika';
  @override
  String get home_text7 => 'Nombre de Jours Travaillés';
  @override
  String get home_text8 => 'Nombre d’Heures Travaillées';
  @override
  String get home_text9 => 'Nombre de Jours de Travail potentiels manqués';
  @override
  String get home_text10 => 'Nombre d’Heures Potientielles de travail manquées';

  ///time sheet screen
  @override
  String get time_text1 => 'Date de Début';
  @override
  String get time_text2 => 'Date de Fin';
  @override
  String get time_text3 => 'Recherche';
  @override
  String get time_text4 => 'Heures Régulières';
  @override
  String get time_text5 => 'Heures Supplémentaire';
  @override
  String get time_text6 => 'Heures d’Urgence';
  @override
  String get time_text7 => 'Êtes-vous Efficace (Oui Non)';
  @override
  String get time_text8 => 'Efficacité';
  @override
  String get time_text9 => "Qu'est-ce que vous Bonus ?";

/*  ///time sheet screen
  @override
  String get time_text1=>'Date de Début';
  @override
  String get time_text2=>'Date de Fin';
  @override
  String get time_text3=>'Recherche';
  @override
  String get time_text4=>'Heures Régulières';
  @override
  String get time_text5=>'Heures Supplémentaire';
  @override
  String get time_text6=>'Heures d’Urgence';
  @override
  String get time_text7=>'Êtes-vous Efficace';
  @override
  String get time_text8=>'Efficacité';*/

  ///inout
  @override
  String get inout_text1 => 'Début d’Urgence';
  @override
  String get inout_text18 => 'Fin d’Urgence';
  @override
  String get inout_text2 => 'Heures Vendues';
  @override
  String get inout_text3 => 'Total d’Heures Travaillées';
  @override
  String get inout_text4 => 'Calcul d’Efficacité';
  @override
  String get inout_text5 => 'Fermer';
  @override
  String get inout_text6 => 'Sauvegarder';
  @override
  String get inout_text7 => 'Heures Vendues';
  @override
  String get inout_text8 => 'Rapport Quotidien';
  @override
  String get inout_text9 => 'Rapport d’Urgence';
  @override
  String get inout_text10 => 'Date';
  @override
  String get inout_text11 => 'Temps Travaillé';
  @override
  String get inout_text12 => 'Heures Régulières';
  @override
  String get inout_text13 => 'Heures Supplémentaire';
  @override
  String get inout_text14 => 'Heures d’Urgence';
  @override
  String get inout_text15 => 'Heures Vendues';
  @override
  String get inout_text16 => 'Temps';
  @override
  String get inout_text17 => 'Heures de Travail';

  @override
  String get inout_text19 => "Heure d'arrivée";
  @override
  String get inout_text20 => 'Heure de départ';

  //// leave
  @override
  String get leave_text1 => 'Jours de Vacances';
  @override
  String get leave_text2 => 'Jours Personnels';
  @override
  String get leave_text3 => 'Congé Non-Payé illimité';
  @override
  String get leave_text4 => 'Congés Annuels';
  @override
  String get leave_text5 => 'Total de Jours';
  @override
  String get leave_text6 => 'Demande de Congé';
  @override
  String get leave_text7 => 'Date de Début';
  @override
  String get leave_text8 => 'Date de Fin';
  @override
  String get leave_text9 => 'Type de Congé';
  @override
  String get leave_text10 => 'Raison';
  @override
  String get leave_text11 => 'Fermer';
  @override
  String get leave_text12 => 'Sauvegarder';

  /// tool
  String get tool_text1 => 'Demande d’Outils';
  @override
  String get tool_text2 => 'Outils';
  @override
  String get tool_text3 => 'Date de Début';
  @override
  String get tool_text4 => 'Date de Fin';
  @override
  String get tool_text5 => 'Raison';
  @override
  String get tool_text6 => 'Approuvé';
  @override
  String get tool_text7 => 'Demandée';
  @override
  String get tool_text8 => 'Rejeté';
  @override
  String get tool_text9 => 'Retourné';
  @override
  String get tool_text10 => 'Non-Retourné';

  @override
  String get tool_text11 => 'Approuvée';

  /// dr
  @override
  String get dr_text1 => 'Horraire de Garde';
  @override
  String get dr_text2 => 'Alerte de Companie';
  @override
  String get dr_text3 => 'Avis';
  @override
  String get dr_text4 => 'Base de Connaissances';
  @override
  String get dr_text5 => 'Supprimer Compte';
  @override
  String get dr_text6 => 'Déconnexion';

  @override
  String get dr_text7 => 'Mot-clé';
  @override
  String get dr_text8 => 'Êtes-vous certain de vouloir vous déconnecter?';
  @override
  String get dr_text9 => 'Êtes-vous certain de vouloir supprimer le compte?';
  @override
  String get dr_text10 => 'Oui';
  @override
  String get dr_text11 => 'Non';
  @override
  // TODO: implement dr_text12
  String get dr_text12 => 'Avertissement aux employés';

  /// pro
  @override
  String get pro_text1 => 'Nom';
  @override
  String get pro_text2 => 'Date de Naissance';
  @override
  String get pro_text3 => 'Courriel';
  @override
  String get pro_text4 => 'Cellulaire';
  @override
  String get pro_text5 => 'Permis de Conduire';
  @override
  String get pro_text6 => 'Permis de Travail ';
  @override
  String get pro_text7 => 'Mettre à Jour';
  @override
  String get pro_text8 => 'Choisir Date';
  @override
  String get pro_text9 => 'Annuler';
  @override
  String get pro_text10 => 'Ok';

  ///login
  @override
  String get login_text1 => 'Nom';
  @override
  String get login_text2 => 'Date de Naissance';
  @override
  String get login_text3 => 'Courriel';

  //employee_warning
  @override
  String get employee_warning1 => 'Avertissement';
  @override
  String get employee_warning2 => 'Date de la réunion précédente';
  @override
  String get employee_warning3 => 'Autres raisons';
  @override
  String get employee_warning4 => 'Détail de l' + "action";
  @override
  String get employee_warning5 => 'Mesures correctives';
}
