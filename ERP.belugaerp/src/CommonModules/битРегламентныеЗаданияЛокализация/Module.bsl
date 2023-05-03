#Область ПрограммныйИнтерфейс

&Вместо("ВыгрузкаСвободныхОстатковВSAP")
Процедура бг_ВыгрузкаСвободныхОстатковВSAP() Экспорт

	бг_битВыгрузкаСвободныхОстатковВSAPИнтеграция.ЗарегистрироватьИсходящиеСообщенияВыгрузкиОстатковВSAP();
	
КонецПроцедуры

&Вместо("ЗагрузкаПриостановленныхЛицензий")
Процедура бг_ЗагрузкаПриостановленныхЛицензий() Экспорт
	бг_ЗагрузкаЛицензий.ЗагрузитьПриостановленныеЛицензии();
КонецПроцедуры

&Вместо("ВыгрузкаИзмененийСвободныхОстатковДляИМ")
Процедура бг_ВыгрузкаИзмененийСвободныхОстатковДляИМ() Экспорт

	бг_битВыгрузкаИзмененийСвободныхОстатковДляИМИнтеграция.ЗарегистрироватьИсходящиеСообщенияДляИМ();
	
КонецПроцедуры

&Вместо("ЗагрузкаДокументовЕГАИС")
Процедура бг_ЗагрузкаДокументовЕГАИС()

	бг_ОбменСЕГАИС.ЗагрузитьДокументы();
	
КонецПроцедуры

&Вместо("ВыгрузкаДокументовЕГАИС")
Процедура бг_ВыгрузкаДокументовЕГАИС()

	бг_ОбменСЕГАИС.ВыгрузитьДокументы();
	
КонецПроцедуры

&Вместо("ВыгрузкаДебиторскойЗадолженностиКонтрагентов")
Процедура бг_ВыгрузкаДебиторскойЗадолженностиКонтрагентов()

	бг_битВыгрузкаДебиторскойЗадолженностиКонтрагентовИнтеграция.ВыполнитьРегламентноеЗадание();

КонецПроцедуры

&Вместо("ВыгрузкаДолгосрочныхРезервовКонтрагентов")
Процедура бг_ВыгрузкаДолгосрочныхРезервовКонтрагентов()

	бг_битВыгрузкаДолгосрочныхРезервовКонтрагентовИнтеграция.ВыполнитьРегламентноеЗадание();

КонецПроцедуры

&Вместо("битВыгрузкаОплатПоЗаказамB2B")
Процедура бг_битВыгрузкаОплатПоЗаказамB2B()
	бг_битВыгрузкаОплатПоЗаказамB2BИнтеграция.ВыполнитьРегламентноеЗадание();
КонецПроцедуры

#КонецОбласти
