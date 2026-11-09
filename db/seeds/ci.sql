-- Gerado por gerar_semente_ci.sh em 2026-11-09. Dados reais (Banco Mundial e FMI), recorte para CI. Não editar à mão.
--
-- PostgreSQL database dump
--

\restrict eoULtSp2F0mwXQub6ydRLirRXDhIw3Am8bWlrWj5soQBRRgSjinCsRNTaKBNDfG

-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: fontes_dados; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.fontes_dados VALUES
	('bm-wdi', 'Banco Mundial, World Development Indicators', 'Banco Mundial', 'https://datacatalog.worldbank.org/search/dataset/0037712/world-development-indicators', 'CC BY 4.0, com termos adicionais do Banco Mundial', 'https://www.worldbank.org/ext/en/legal/terms-conditions/datasets', 'The World Bank: World Development Indicators', 'Atualizações periódicas; data informada pela API (lastupdated)', 'Não sugerir endosso do Banco Mundial. Citar também a organização de origem do indicador.'),
	('fmi-weo', 'FMI, World Economic Outlook', 'FMI', 'https://data.imf.org/en/datasets/IMF.RES:WEO', 'Termos de uso de dados do FMI: uso e redistribuição com atribuição; reuso comercial exige permissão', 'https://www.imf.org/en/about/copyright-and-terms', 'International Monetary Fund. World Economic Outlook (WEO), https://data.imf.org/en/datasets/IMF.RES:WEO', 'Semestral (abril e outubro)', 'Só anos observados (até LATEST_ACTUAL_ANNUAL_DATA); projeções não são gravadas. Consulta dirigida via API oficial, sem download em massa.'),
	('natural-earth', 'Natural Earth (via pacote world-atlas 2.0.2)', 'Natural Earth', 'https://www.naturalearthdata.com/', 'Domínio público (pacote world-atlas: ISC)', 'https://www.naturalearthdata.com/about/terms-of-use/', 'Made with Natural Earth', 'Estática (Natural Earth 4.1.0)', 'Fronteiras de facto.'),
	('iso-3166', 'ISO 3166-1 (via pycountry / iso-codes)', 'ISO 3166', 'https://pypi.org/project/pycountry/', 'LGPL 2.1 (pycountry)', 'https://pypi.org/project/pycountry/', 'ISO 3166-1, via pycountry', 'A cada versão do pacote', 'Nomes em português revisados pelo rotzx (ver ingest/sources/nomes_pt.py).');


--
-- Data for Name: indicadores; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.indicadores VALUES
	('pib', 'PIB', 'USD', 'economia', 'Produto interno bruto em dólares correntes.', 'bm-wdi', 'NY.GDP.MKTP.CD', NULL),
	('pib_crescimento', 'Crescimento do PIB', '%', 'economia', 'Variação anual do PIB real, a preços constantes.', 'bm-wdi', 'NY.GDP.MKTP.KD.ZG', NULL),
	('pib_per_capita', 'PIB per capita', 'USD', 'economia', 'PIB em dólares correntes dividido pela população.', 'bm-wdi', 'NY.GDP.PCAP.CD', NULL),
	('inflacao', 'Inflação', '%', 'economia', 'Variação anual dos preços ao consumidor.', 'bm-wdi', 'FP.CPI.TOTL.ZG', NULL),
	('desemprego', 'Desemprego', '%', 'social', 'Desempregados como percentual da força de trabalho.', 'bm-wdi', 'SL.UEM.TOTL.ZS', 'Estimativa modelada da OIT, não o número oficial divulgado pelo país.'),
	('divida_publica_pib', 'Dívida pública', '% do PIB', 'economia', 'Dívida bruta do governo geral como percentual do PIB.', 'fmi-weo', 'GGXWDG_NGDP', 'Governo geral (inclui governos subnacionais). Só anos observados, sem projeções do FMI.'),
	('balanca_bens_servicos', 'Balança de bens e serviços', 'USD', 'comercio', 'Exportações menos importações de bens e serviços, em dólares correntes.', 'bm-wdi', 'NE.RSB.GNFS.CD', 'Inclui serviços; não é só a balança comercial de mercadorias.'),
	('populacao', 'População', 'pessoas', 'social', 'População total residente.', 'bm-wdi', 'SP.POP.TOTL', NULL);


--
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.paises VALUES
	('ATF', 'TF', '260', 'Territórios Franceses do Sul', 'French Southern Territories', NULL, false, '260', '2026-11-09 15:18:04.798313+00'),
	('ATG', 'AG', '028', 'Antígua e Barbuda', 'Antigua and Barbuda', 'América Latina e Caribe', false, '028', '2026-11-09 15:18:04.798313+00'),
	('AUS', 'AU', '036', 'Austrália', 'Australia', 'Leste Asiático e Pacífico', true, '036', '2026-11-09 15:18:04.798313+00'),
	('AUT', 'AT', '040', 'Áustria', 'Austria', 'Europa e Ásia Central', false, '040', '2026-11-09 15:18:04.798313+00'),
	('AZE', 'AZ', '031', 'Azerbaidjão', 'Azerbaijan', 'Europa e Ásia Central', false, '031', '2026-11-09 15:18:04.798313+00'),
	('BDI', 'BI', '108', 'Burundi', 'Burundi', 'África Subsaariana', false, '108', '2026-11-09 15:18:04.798313+00'),
	('BEL', 'BE', '056', 'Bélgica', 'Belgium', 'Europa e Ásia Central', false, '056', '2026-11-09 15:18:04.798313+00'),
	('BES', 'BQ', '535', 'Bonaire, Saba e Santo Eustáquio', 'Bonaire, Sint Eustatius and Saba', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('BFA', 'BF', '854', 'Burquina', 'Burkina Faso', 'África Subsaariana', false, '854', '2026-11-09 15:18:04.798313+00'),
	('BGD', 'BD', '050', 'Bangladesh', 'Bangladesh', 'Sul da Ásia', false, '050', '2026-11-09 15:18:04.798313+00'),
	('BGR', 'BG', '100', 'Bulgária', 'Bulgaria', 'Europa e Ásia Central', false, '100', '2026-11-09 15:18:04.798313+00'),
	('BHR', 'BH', '048', 'Barein', 'Bahrain', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '048', '2026-11-09 15:18:04.798313+00'),
	('BHS', 'BS', '044', 'Bahamas', 'Bahamas', 'América Latina e Caribe', false, '044', '2026-11-09 15:18:04.798313+00'),
	('BIH', 'BA', '070', 'Bósnia-Herzegóvina', 'Bosnia and Herzegovina', 'Europa e Ásia Central', false, '070', '2026-11-09 15:18:04.798313+00'),
	('BLM', 'BL', '652', 'São Bartolomeu', 'Saint Barthélemy', NULL, false, '652', '2026-11-09 15:18:04.798313+00'),
	('BLR', 'BY', '112', 'Bielo-Rússia', 'Belarus', 'Europa e Ásia Central', false, '112', '2026-11-09 15:18:04.798313+00'),
	('BLZ', 'BZ', '084', 'Belize', 'Belize', 'América Latina e Caribe', false, '084', '2026-11-09 15:18:04.798313+00'),
	('BMU', 'BM', '060', 'Bermuda', 'Bermuda', 'América do Norte', false, '060', '2026-11-09 15:18:04.798313+00'),
	('BOL', 'BO', '068', 'Bolívia', 'Bolivia', 'América Latina e Caribe', true, '068', '2026-11-09 15:18:04.798313+00'),
	('BRA', 'BR', '076', 'Brasil', 'Brazil', 'América Latina e Caribe', true, '076', '2026-11-09 15:18:04.798313+00'),
	('BRB', 'BB', '052', 'Barbados', 'Barbados', 'América Latina e Caribe', false, '052', '2026-11-09 15:18:04.798313+00'),
	('BRN', 'BN', '096', 'Brunei', 'Brunei Darussalam', 'Leste Asiático e Pacífico', false, '096', '2026-11-09 15:18:04.798313+00'),
	('BTN', 'BT', '064', 'Butão', 'Bhutan', 'Sul da Ásia', false, '064', '2026-11-09 15:18:04.798313+00'),
	('BVT', 'BV', '074', 'Ilha Bouvet', 'Bouvet Island', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('BWA', 'BW', '072', 'Botsuana', 'Botswana', 'África Subsaariana', false, '072', '2026-11-09 15:18:04.798313+00'),
	('CAF', 'CF', '140', 'República Centro-Africana', 'Central African Republic', 'África Subsaariana', false, '140', '2026-11-09 15:18:04.798313+00'),
	('CAN', 'CA', '124', 'Canadá', 'Canada', 'América do Norte', true, '124', '2026-11-09 15:18:04.798313+00'),
	('CCK', 'CC', '166', 'Ilhas Cocos', 'Cocos (Keeling) Islands', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('CHE', 'CH', '756', 'Suíça', 'Switzerland', 'Europa e Ásia Central', false, '756', '2026-11-09 15:18:04.798313+00'),
	('CHL', 'CL', '152', 'Chile', 'Chile', 'América Latina e Caribe', false, '152', '2026-11-09 15:18:04.798313+00'),
	('CHN', 'CN', '156', 'China', 'China', 'Leste Asiático e Pacífico', true, '156', '2026-11-09 15:18:04.798313+00'),
	('CIV', 'CI', '384', 'Costa do Marfim', 'Côte d''Ivoire', 'África Subsaariana', false, '384', '2026-11-09 15:18:04.798313+00'),
	('CMR', 'CM', '120', 'Camarões', 'Cameroon', 'África Subsaariana', false, '120', '2026-11-09 15:18:04.798313+00'),
	('COD', 'CD', '180', 'República Democrática do Congo', 'Congo, The Democratic Republic of the', 'África Subsaariana', false, '180', '2026-11-09 15:18:04.798313+00'),
	('COG', 'CG', '178', 'República do Congo', 'Congo', 'África Subsaariana', false, '178', '2026-11-09 15:18:04.798313+00'),
	('COK', 'CK', '184', 'Ilhas Cook', 'Cook Islands', NULL, false, '184', '2026-11-09 15:18:04.798313+00'),
	('COL', 'CO', '170', 'Colômbia', 'Colombia', 'América Latina e Caribe', true, '170', '2026-11-09 15:18:04.798313+00'),
	('COM', 'KM', '174', 'Comores', 'Comoros', 'África Subsaariana', false, '174', '2026-11-09 15:18:04.798313+00'),
	('CPV', 'CV', '132', 'Cabo Verde', 'Cabo Verde', 'África Subsaariana', false, '132', '2026-11-09 15:18:04.798313+00'),
	('CRI', 'CR', '188', 'Costa Rica', 'Costa Rica', 'América Latina e Caribe', false, '188', '2026-11-09 15:18:04.798313+00'),
	('CUB', 'CU', '192', 'Cuba', 'Cuba', 'América Latina e Caribe', false, '192', '2026-11-09 15:18:04.798313+00'),
	('CUW', 'CW', '531', 'Curaçao', 'Curaçao', 'América Latina e Caribe', false, '531', '2026-11-09 15:18:04.798313+00'),
	('CXR', 'CX', '162', 'Ilha Christmas', 'Christmas Island', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('CYM', 'KY', '136', 'Ilhas Cayman', 'Cayman Islands', 'América Latina e Caribe', false, '136', '2026-11-09 15:18:04.798313+00'),
	('CYP', 'CY', '196', 'Chipre', 'Cyprus', 'Europa e Ásia Central', false, '196', '2026-11-09 15:18:04.798313+00'),
	('CZE', 'CZ', '203', 'Chéquia', 'Czechia', 'Europa e Ásia Central', false, '203', '2026-11-09 15:18:04.798313+00'),
	('DEU', 'DE', '276', 'Alemanha', 'Germany', 'Europa e Ásia Central', true, '276', '2026-11-09 15:18:04.798313+00'),
	('DJI', 'DJ', '262', 'Djibuti', 'Djibouti', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '262', '2026-11-09 15:18:04.798313+00'),
	('DMA', 'DM', '212', 'Domínica', 'Dominica', 'América Latina e Caribe', false, '212', '2026-11-09 15:18:04.798313+00'),
	('DNK', 'DK', '208', 'Dinamarca', 'Denmark', 'Europa e Ásia Central', false, '208', '2026-11-09 15:18:04.798313+00'),
	('DOM', 'DO', '214', 'República Dominicana', 'Dominican Republic', 'América Latina e Caribe', false, '214', '2026-11-09 15:18:04.798313+00'),
	('DZA', 'DZ', '012', 'Argélia', 'Algeria', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '012', '2026-11-09 15:18:04.798313+00'),
	('ECU', 'EC', '218', 'Equador', 'Ecuador', 'América Latina e Caribe', false, '218', '2026-11-09 15:18:04.798313+00'),
	('EGY', 'EG', '818', 'Egito', 'Egypt', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '818', '2026-11-09 15:18:04.798313+00'),
	('ERI', 'ER', '232', 'Eritréia', 'Eritrea', 'África Subsaariana', false, '232', '2026-11-09 15:18:04.798313+00'),
	('ESH', 'EH', '732', 'Saara Ocidental', 'Western Sahara', NULL, false, '732', '2026-11-09 15:18:04.798313+00'),
	('ESP', 'ES', '724', 'Espanha', 'Spain', 'Europa e Ásia Central', false, '724', '2026-11-09 15:18:04.798313+00'),
	('EST', 'EE', '233', 'Estônia', 'Estonia', 'Europa e Ásia Central', false, '233', '2026-11-09 15:18:04.798313+00'),
	('ETH', 'ET', '231', 'Etiópia', 'Ethiopia', 'África Subsaariana', false, '231', '2026-11-09 15:18:04.798313+00'),
	('FIN', 'FI', '246', 'Finlândia', 'Finland', 'Europa e Ásia Central', false, '246', '2026-11-09 15:18:04.798313+00'),
	('FJI', 'FJ', '242', 'Fiji', 'Fiji', 'Leste Asiático e Pacífico', false, '242', '2026-11-09 15:18:04.798313+00'),
	('FLK', 'FK', '238', 'Ilhas Malvinas (Falkland)', 'Falkland Islands (Malvinas)', NULL, false, '238', '2026-11-09 15:18:04.798313+00'),
	('FRA', 'FR', '250', 'França', 'France', 'Europa e Ásia Central', true, '250', '2026-11-09 15:18:04.798313+00'),
	('FRO', 'FO', '234', 'Ilhas Faroe', 'Faroe Islands', 'Europa e Ásia Central', false, '234', '2026-11-09 15:18:04.798313+00'),
	('FSM', 'FM', '583', 'Micronésia', 'Micronesia, Federated States of', 'Leste Asiático e Pacífico', false, '583', '2026-11-09 15:18:04.798313+00'),
	('GAB', 'GA', '266', 'Gabão', 'Gabon', 'África Subsaariana', false, '266', '2026-11-09 15:18:04.798313+00'),
	('GBR', 'GB', '826', 'Reino Unido', 'United Kingdom', 'Europa e Ásia Central', true, '826', '2026-11-09 15:18:04.798313+00'),
	('GEO', 'GE', '268', 'Geórgia', 'Georgia', 'Europa e Ásia Central', false, '268', '2026-11-09 15:18:04.798313+00'),
	('GGY', 'GG', '831', 'Guernsey', 'Guernsey', NULL, false, '831', '2026-11-09 15:18:04.798313+00'),
	('GHA', 'GH', '288', 'Gana', 'Ghana', 'África Subsaariana', false, '288', '2026-11-09 15:18:04.798313+00'),
	('GIB', 'GI', '292', 'Gibraltar', 'Gibraltar', 'Europa e Ásia Central', false, NULL, '2026-11-09 15:18:04.798313+00'),
	('GIN', 'GN', '324', 'Guiné', 'Guinea', 'África Subsaariana', false, '324', '2026-11-09 15:18:04.798313+00'),
	('GLP', 'GP', '312', 'Guadalupe', 'Guadeloupe', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('GMB', 'GM', '270', 'Gâmbia', 'Gambia', 'África Subsaariana', false, '270', '2026-11-09 15:18:04.798313+00'),
	('GNB', 'GW', '624', 'Guiné-Bissau', 'Guinea-Bissau', 'África Subsaariana', false, '624', '2026-11-09 15:18:04.798313+00'),
	('GNQ', 'GQ', '226', 'Guiné Equatorial', 'Equatorial Guinea', 'África Subsaariana', false, '226', '2026-11-09 15:18:04.798313+00'),
	('GRC', 'GR', '300', 'Grécia', 'Greece', 'Europa e Ásia Central', false, '300', '2026-11-09 15:18:04.798313+00'),
	('GRD', 'GD', '308', 'Granada', 'Grenada', 'América Latina e Caribe', false, '308', '2026-11-09 15:18:04.798313+00'),
	('GRL', 'GL', '304', 'Groenlândia', 'Greenland', 'Europa e Ásia Central', false, '304', '2026-11-09 15:18:04.798313+00'),
	('GTM', 'GT', '320', 'Guatemala', 'Guatemala', 'América Latina e Caribe', false, '320', '2026-11-09 15:18:04.798313+00'),
	('GUF', 'GF', '254', 'Guiana Francesa', 'French Guiana', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('GUM', 'GU', '316', 'Guam', 'Guam', 'Leste Asiático e Pacífico', false, '316', '2026-11-09 15:18:04.798313+00'),
	('GUY', 'GY', '328', 'Guiana', 'Guyana', 'América Latina e Caribe', true, '328', '2026-11-09 15:18:04.798313+00'),
	('HKG', 'HK', '344', 'Hong Kong', 'Hong Kong', 'Leste Asiático e Pacífico', false, '344', '2026-11-09 15:18:04.798313+00'),
	('HMD', 'HM', '334', 'Ilha Heard e Ilhas McDonald', 'Heard Island and McDonald Islands', NULL, false, '334', '2026-11-09 15:18:04.798313+00'),
	('HND', 'HN', '340', 'Honduras', 'Honduras', 'América Latina e Caribe', false, '340', '2026-11-09 15:18:04.798313+00'),
	('HRV', 'HR', '191', 'Croácia', 'Croatia', 'Europa e Ásia Central', false, '191', '2026-11-09 15:18:04.798313+00'),
	('HTI', 'HT', '332', 'Haiti', 'Haiti', 'América Latina e Caribe', false, '332', '2026-11-09 15:18:04.798313+00'),
	('HUN', 'HU', '348', 'Hungria', 'Hungary', 'Europa e Ásia Central', false, '348', '2026-11-09 15:18:04.798313+00'),
	('IDN', 'ID', '360', 'Indonésia', 'Indonesia', 'Leste Asiático e Pacífico', true, '360', '2026-11-09 15:18:04.798313+00'),
	('IMN', 'IM', '833', 'Ilha de Man', 'Isle of Man', 'Europa e Ásia Central', false, '833', '2026-11-09 15:18:04.798313+00'),
	('IND', 'IN', '356', 'Índia', 'India', 'Sul da Ásia', true, '356', '2026-11-09 15:18:04.798313+00'),
	('IOT', 'IO', '086', 'Território Britânico do Oceano Índico', 'British Indian Ocean Territory', NULL, false, '086', '2026-11-09 15:18:04.798313+00'),
	('IRL', 'IE', '372', 'Irlanda', 'Ireland', 'Europa e Ásia Central', false, '372', '2026-11-09 15:18:04.798313+00'),
	('IRN', 'IR', '364', 'Irã', 'Iran', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '364', '2026-11-09 15:18:04.798313+00'),
	('IRQ', 'IQ', '368', 'Iraque', 'Iraq', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '368', '2026-11-09 15:18:04.798313+00'),
	('ISL', 'IS', '352', 'Islândia', 'Iceland', 'Europa e Ásia Central', false, '352', '2026-11-09 15:18:04.798313+00'),
	('ISR', 'IL', '376', 'Israel', 'Israel', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '376', '2026-11-09 15:18:04.798313+00'),
	('ITA', 'IT', '380', 'Itália', 'Italy', 'Europa e Ásia Central', true, '380', '2026-11-09 15:18:04.798313+00'),
	('JAM', 'JM', '388', 'Jamaica', 'Jamaica', 'América Latina e Caribe', false, '388', '2026-11-09 15:18:04.798313+00'),
	('JEY', 'JE', '832', 'Jersey', 'Jersey', NULL, false, '832', '2026-11-09 15:18:04.798313+00'),
	('JOR', 'JO', '400', 'Jordânia', 'Jordan', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '400', '2026-11-09 15:18:04.798313+00'),
	('JPN', 'JP', '392', 'Japão', 'Japan', 'Leste Asiático e Pacífico', true, '392', '2026-11-09 15:18:04.798313+00'),
	('KAZ', 'KZ', '398', 'Cazaquistão', 'Kazakhstan', 'Europa e Ásia Central', false, '398', '2026-11-09 15:18:04.798313+00'),
	('KEN', 'KE', '404', 'Quênia', 'Kenya', 'África Subsaariana', false, '404', '2026-11-09 15:18:04.798313+00'),
	('KGZ', 'KG', '417', 'Quirguistão', 'Kyrgyzstan', 'Europa e Ásia Central', false, '417', '2026-11-09 15:18:04.798313+00'),
	('KHM', 'KH', '116', 'Camboja', 'Cambodia', 'Leste Asiático e Pacífico', false, '116', '2026-11-09 15:18:04.798313+00'),
	('KIR', 'KI', '296', 'Kiribati', 'Kiribati', 'Leste Asiático e Pacífico', false, '296', '2026-11-09 15:18:04.798313+00'),
	('KNA', 'KN', '659', 'São Cristóvão e Névis', 'Saint Kitts and Nevis', 'América Latina e Caribe', false, '659', '2026-11-09 15:18:04.798313+00'),
	('KOR', 'KR', '410', 'Coreia do Sul', 'South Korea', 'Leste Asiático e Pacífico', true, '410', '2026-11-09 15:18:04.798313+00'),
	('KWT', 'KW', '414', 'Kuwait', 'Kuwait', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '414', '2026-11-09 15:18:04.798313+00'),
	('LAO', 'LA', '418', 'Laos', 'Laos', 'Leste Asiático e Pacífico', false, '418', '2026-11-09 15:18:04.798313+00'),
	('LBN', 'LB', '422', 'Líbano', 'Lebanon', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '422', '2026-11-09 15:18:04.798313+00'),
	('LBR', 'LR', '430', 'Libéria', 'Liberia', 'África Subsaariana', false, '430', '2026-11-09 15:18:04.798313+00'),
	('LBY', 'LY', '434', 'Líbia', 'Libya', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '434', '2026-11-09 15:18:04.798313+00'),
	('LCA', 'LC', '662', 'Santa Lúcia', 'Saint Lucia', 'América Latina e Caribe', false, '662', '2026-11-09 15:18:04.798313+00'),
	('LIE', 'LI', '438', 'Liechtenstein', 'Liechtenstein', 'Europa e Ásia Central', false, '438', '2026-11-09 15:18:04.798313+00'),
	('LKA', 'LK', '144', 'Sri Lanka', 'Sri Lanka', 'Sul da Ásia', false, '144', '2026-11-09 15:18:04.798313+00'),
	('LSO', 'LS', '426', 'Lesoto', 'Lesotho', 'África Subsaariana', false, '426', '2026-11-09 15:18:04.798313+00'),
	('LTU', 'LT', '440', 'Lituânia', 'Lithuania', 'Europa e Ásia Central', false, '440', '2026-11-09 15:18:04.798313+00'),
	('LUX', 'LU', '442', 'Luxemburgo', 'Luxembourg', 'Europa e Ásia Central', false, '442', '2026-11-09 15:18:04.798313+00'),
	('LVA', 'LV', '428', 'Letônia', 'Latvia', 'Europa e Ásia Central', false, '428', '2026-11-09 15:18:04.798313+00'),
	('MAC', 'MO', '446', 'Macau', 'Macao', 'Leste Asiático e Pacífico', false, '446', '2026-11-09 15:18:04.798313+00'),
	('MAF', 'MF', '663', 'São Martim (parte francesa)', 'Saint Martin (French part)', 'América Latina e Caribe', false, '663', '2026-11-09 15:18:04.798313+00'),
	('MAR', 'MA', '504', 'Marrocos', 'Morocco', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '504', '2026-11-09 15:18:04.798313+00'),
	('MCO', 'MC', '492', 'Mônaco', 'Monaco', 'Europa e Ásia Central', false, '492', '2026-11-09 15:18:04.798313+00'),
	('MDA', 'MD', '498', 'Moldávia', 'Moldova', 'Europa e Ásia Central', false, '498', '2026-11-09 15:18:04.798313+00'),
	('MDG', 'MG', '450', 'Madagascar', 'Madagascar', 'África Subsaariana', false, '450', '2026-11-09 15:18:04.798313+00'),
	('MDV', 'MV', '462', 'Maldivas', 'Maldives', 'Sul da Ásia', false, '462', '2026-11-09 15:18:04.798313+00'),
	('MEX', 'MX', '484', 'México', 'Mexico', 'América Latina e Caribe', true, '484', '2026-11-09 15:18:04.798313+00'),
	('MHL', 'MH', '584', 'Ilhas Marshall', 'Marshall Islands', 'Leste Asiático e Pacífico', false, '584', '2026-11-09 15:18:04.798313+00'),
	('MKD', 'MK', '807', 'Macedônia do Norte', 'North Macedonia', 'Europa e Ásia Central', false, '807', '2026-11-09 15:18:04.798313+00'),
	('MLT', 'MT', '470', 'Malta', 'Malta', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '470', '2026-11-09 15:18:04.798313+00'),
	('MMR', 'MM', '104', 'Mianmar', 'Myanmar', 'Leste Asiático e Pacífico', false, '104', '2026-11-09 15:18:04.798313+00'),
	('MNE', 'ME', '499', 'Montenegro', 'Montenegro', 'Europa e Ásia Central', false, '499', '2026-11-09 15:18:04.798313+00'),
	('MNG', 'MN', '496', 'Mongólia', 'Mongolia', 'Leste Asiático e Pacífico', false, '496', '2026-11-09 15:18:04.798313+00'),
	('MNP', 'MP', '580', 'Ilhas Marianas do Norte', 'Northern Mariana Islands', 'Leste Asiático e Pacífico', false, '580', '2026-11-09 15:18:04.798313+00'),
	('MOZ', 'MZ', '508', 'Moçambique', 'Mozambique', 'África Subsaariana', false, '508', '2026-11-09 15:18:04.798313+00'),
	('MRT', 'MR', '478', 'Mauritânia', 'Mauritania', 'África Subsaariana', false, '478', '2026-11-09 15:18:04.798313+00'),
	('MSR', 'MS', '500', 'Montserrat', 'Montserrat', NULL, false, '500', '2026-11-09 15:18:04.798313+00'),
	('MTQ', 'MQ', '474', 'Martinica', 'Martinique', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('MUS', 'MU', '480', 'Maurício', 'Mauritius', 'África Subsaariana', false, '480', '2026-11-09 15:18:04.798313+00'),
	('MWI', 'MW', '454', 'Malaui', 'Malawi', 'África Subsaariana', false, '454', '2026-11-09 15:18:04.798313+00'),
	('MYS', 'MY', '458', 'Malásia', 'Malaysia', 'Leste Asiático e Pacífico', false, '458', '2026-11-09 15:18:04.798313+00'),
	('NAM', 'NA', '516', 'Namíbia', 'Namibia', 'África Subsaariana', false, '516', '2026-11-09 15:18:04.798313+00'),
	('NCL', 'NC', '540', 'Nova Caledônia', 'New Caledonia', 'Leste Asiático e Pacífico', false, '540', '2026-11-09 15:18:04.798313+00'),
	('NER', 'NE', '562', 'Níger', 'Niger', 'África Subsaariana', false, '562', '2026-11-09 15:18:04.798313+00'),
	('NFK', 'NF', '574', 'Ilha Norfolk', 'Norfolk Island', NULL, false, '574', '2026-11-09 15:18:04.798313+00'),
	('NGA', 'NG', '566', 'Nigéria', 'Nigeria', 'África Subsaariana', false, '566', '2026-11-09 15:18:04.798313+00'),
	('NIC', 'NI', '558', 'Nicarágua', 'Nicaragua', 'América Latina e Caribe', false, '558', '2026-11-09 15:18:04.798313+00'),
	('NIU', 'NU', '570', 'Niue', 'Niue', NULL, false, '570', '2026-11-09 15:18:04.798313+00'),
	('NLD', 'NL', '528', 'Países Baixos', 'Netherlands', 'Europa e Ásia Central', false, '528', '2026-11-09 15:18:04.798313+00'),
	('NOR', 'NO', '578', 'Noruega', 'Norway', 'Europa e Ásia Central', false, '578', '2026-11-09 15:18:04.798313+00'),
	('NPL', 'NP', '524', 'Nepal', 'Nepal', 'Sul da Ásia', false, '524', '2026-11-09 15:18:04.798313+00'),
	('NRU', 'NR', '520', 'Nauru', 'Nauru', 'Leste Asiático e Pacífico', false, '520', '2026-11-09 15:18:04.798313+00'),
	('NZL', 'NZ', '554', 'Nova Zelândia', 'New Zealand', 'Leste Asiático e Pacífico', false, '554', '2026-11-09 15:18:04.798313+00'),
	('OMN', 'OM', '512', 'Omã', 'Oman', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '512', '2026-11-09 15:18:04.798313+00'),
	('PAK', 'PK', '586', 'Paquistão', 'Pakistan', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '586', '2026-11-09 15:18:04.798313+00'),
	('PAN', 'PA', '591', 'Panamá', 'Panama', 'América Latina e Caribe', false, '591', '2026-11-09 15:18:04.798313+00'),
	('PCN', 'PN', '612', 'Pitcairn', 'Pitcairn', NULL, false, '612', '2026-11-09 15:18:04.798313+00'),
	('MLI', 'ML', '466', 'Mali', 'Mali', 'África Subsaariana', false, '466', '2026-11-09 15:18:04.798313+00'),
	('PER', 'PE', '604', 'Peru', 'Peru', 'América Latina e Caribe', true, '604', '2026-11-09 15:18:04.798313+00'),
	('PHL', 'PH', '608', 'Filipinas', 'Philippines', 'Leste Asiático e Pacífico', false, '608', '2026-11-09 15:18:04.798313+00'),
	('PLW', 'PW', '585', 'Palau', 'Palau', 'Leste Asiático e Pacífico', false, '585', '2026-11-09 15:18:04.798313+00'),
	('PNG', 'PG', '598', 'Papua-Nova Guiné', 'Papua New Guinea', 'Leste Asiático e Pacífico', false, '598', '2026-11-09 15:18:04.798313+00'),
	('POL', 'PL', '616', 'Polônia', 'Poland', 'Europa e Ásia Central', false, '616', '2026-11-09 15:18:04.798313+00'),
	('PRI', 'PR', '630', 'Porto Rico', 'Puerto Rico', 'América Latina e Caribe', false, '630', '2026-11-09 15:18:04.798313+00'),
	('PRK', 'KP', '408', 'Coreia do Norte', 'North Korea', 'Leste Asiático e Pacífico', false, '408', '2026-11-09 15:18:04.798313+00'),
	('PRT', 'PT', '620', 'Portugal', 'Portugal', 'Europa e Ásia Central', false, '620', '2026-11-09 15:18:04.798313+00'),
	('PRY', 'PY', '600', 'Paraguai', 'Paraguay', 'América Latina e Caribe', true, '600', '2026-11-09 15:18:04.798313+00'),
	('PSE', 'PS', '275', 'Palestina', 'Palestine, State of', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '275', '2026-11-09 15:18:04.798313+00'),
	('PYF', 'PF', '258', 'Polinésia Francesa', 'French Polynesia', 'Leste Asiático e Pacífico', false, '258', '2026-11-09 15:18:04.798313+00'),
	('QAT', 'QA', '634', 'Catar', 'Qatar', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '634', '2026-11-09 15:18:04.798313+00'),
	('REU', 'RE', '638', 'Reunião', 'Réunion', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('ROU', 'RO', '642', 'Romênia', 'Romania', 'Europa e Ásia Central', false, '642', '2026-11-09 15:18:04.798313+00'),
	('RUS', 'RU', '643', 'Rússia', 'Russian Federation', 'Europa e Ásia Central', true, '643', '2026-11-09 15:18:04.798313+00'),
	('RWA', 'RW', '646', 'Ruanda', 'Rwanda', 'África Subsaariana', false, '646', '2026-11-09 15:18:04.798313+00'),
	('SAU', 'SA', '682', 'Arábia Saudita', 'Saudi Arabia', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', true, '682', '2026-11-09 15:18:04.798313+00'),
	('SDN', 'SD', '729', 'Sudão', 'Sudan', 'África Subsaariana', false, '729', '2026-11-09 15:18:04.798313+00'),
	('SEN', 'SN', '686', 'Senegal', 'Senegal', 'África Subsaariana', false, '686', '2026-11-09 15:18:04.798313+00'),
	('SGP', 'SG', '702', 'Cingapura', 'Singapore', 'Leste Asiático e Pacífico', false, '702', '2026-11-09 15:18:04.798313+00'),
	('SGS', 'GS', '239', 'Geórgia do Sul e Ilhas Sandwich do Sul', 'South Georgia and the South Sandwich Islands', NULL, false, '239', '2026-11-09 15:18:04.798313+00'),
	('SHN', 'SH', '654', 'Santa Helena, Ascensão e Tristão da Cunha', 'Saint Helena, Ascension and Tristan da Cunha', NULL, false, '654', '2026-11-09 15:18:04.798313+00'),
	('SJM', 'SJ', '744', 'Svalbard e a Ilha de Jan Mayen', 'Svalbard and Jan Mayen', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('SLB', 'SB', '090', 'Ilhas Salomão', 'Solomon Islands', 'Leste Asiático e Pacífico', false, '090', '2026-11-09 15:18:04.798313+00'),
	('SLE', 'SL', '694', 'Serra Leoa', 'Sierra Leone', 'África Subsaariana', false, '694', '2026-11-09 15:18:04.798313+00'),
	('SLV', 'SV', '222', 'El Salvador', 'El Salvador', 'América Latina e Caribe', false, '222', '2026-11-09 15:18:04.798313+00'),
	('SMR', 'SM', '674', 'São Marino', 'San Marino', 'Europa e Ásia Central', false, '674', '2026-11-09 15:18:04.798313+00'),
	('SOM', 'SO', '706', 'Somália', 'Somalia', 'África Subsaariana', false, '706', '2026-11-09 15:18:04.798313+00'),
	('SPM', 'PM', '666', 'São Pedro e Miquelon', 'Saint Pierre and Miquelon', NULL, false, '666', '2026-11-09 15:18:04.798313+00'),
	('SRB', 'RS', '688', 'Sérvia', 'Serbia', 'Europa e Ásia Central', false, '688', '2026-11-09 15:18:04.798313+00'),
	('SSD', 'SS', '728', 'Sudão do Sul', 'South Sudan', 'África Subsaariana', false, '728', '2026-11-09 15:18:04.798313+00'),
	('STP', 'ST', '678', 'São Tomé e Príncipe', 'Sao Tome and Principe', 'África Subsaariana', false, '678', '2026-11-09 15:18:04.798313+00'),
	('SUR', 'SR', '740', 'Suriname', 'Suriname', 'América Latina e Caribe', true, '740', '2026-11-09 15:18:04.798313+00'),
	('SVK', 'SK', '703', 'Eslováquia', 'Slovakia', 'Europa e Ásia Central', false, '703', '2026-11-09 15:18:04.798313+00'),
	('SVN', 'SI', '705', 'Eslovênia', 'Slovenia', 'Europa e Ásia Central', false, '705', '2026-11-09 15:18:04.798313+00'),
	('SWE', 'SE', '752', 'Suécia', 'Sweden', 'Europa e Ásia Central', false, '752', '2026-11-09 15:18:04.798313+00'),
	('SWZ', 'SZ', '748', 'Suazilândia', 'Eswatini', 'África Subsaariana', false, '748', '2026-11-09 15:18:04.798313+00'),
	('SXM', 'SX', '534', 'São Martim (parte holandesa)', 'Sint Maarten (Dutch part)', 'América Latina e Caribe', false, '534', '2026-11-09 15:18:04.798313+00'),
	('SYC', 'SC', '690', 'Seychelles', 'Seychelles', 'África Subsaariana', false, '690', '2026-11-09 15:18:04.798313+00'),
	('SYR', 'SY', '760', 'Síria', 'Syria', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '760', '2026-11-09 15:18:04.798313+00'),
	('TCA', 'TC', '796', 'Ilhas Turks e Caicos', 'Turks and Caicos Islands', 'América Latina e Caribe', false, '796', '2026-11-09 15:18:04.798313+00'),
	('TCD', 'TD', '148', 'Chade', 'Chad', 'África Subsaariana', false, '148', '2026-11-09 15:18:04.798313+00'),
	('TGO', 'TG', '768', 'Togo', 'Togo', 'África Subsaariana', false, '768', '2026-11-09 15:18:04.798313+00'),
	('THA', 'TH', '764', 'Tailândia', 'Thailand', 'Leste Asiático e Pacífico', false, '764', '2026-11-09 15:18:04.798313+00'),
	('TJK', 'TJ', '762', 'Tadjiquistão', 'Tajikistan', 'Europa e Ásia Central', false, '762', '2026-11-09 15:18:04.798313+00'),
	('TKL', 'TK', '772', 'Toquelau', 'Tokelau', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('TKM', 'TM', '795', 'Turcomenistão', 'Turkmenistan', 'Europa e Ásia Central', false, '795', '2026-11-09 15:18:04.798313+00'),
	('TLS', 'TL', '626', 'Timor Leste', 'Timor-Leste', 'Leste Asiático e Pacífico', false, '626', '2026-11-09 15:18:04.798313+00'),
	('TON', 'TO', '776', 'Tonga', 'Tonga', 'Leste Asiático e Pacífico', false, '776', '2026-11-09 15:18:04.798313+00'),
	('VEN', 'VE', '862', 'Venezuela', 'Venezuela', 'América Latina e Caribe', true, '862', '2026-11-09 15:18:04.798313+00'),
	('ABW', 'AW', '533', 'Aruba', 'Aruba', 'América Latina e Caribe', false, '533', '2026-11-09 15:18:04.798313+00'),
	('AFG', 'AF', '004', 'Afeganistão', 'Afghanistan', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '004', '2026-11-09 15:18:04.798313+00'),
	('AGO', 'AO', '024', 'Angola', 'Angola', 'África Subsaariana', false, '024', '2026-11-09 15:18:04.798313+00'),
	('AIA', 'AI', '660', 'Anguila', 'Anguilla', NULL, false, '660', '2026-11-09 15:18:04.798313+00'),
	('ALA', 'AX', '248', 'Ilhas Åland', 'Åland Islands', NULL, false, '248', '2026-11-09 15:18:04.798313+00'),
	('ALB', 'AL', '008', 'Albânia', 'Albania', 'Europa e Ásia Central', false, '008', '2026-11-09 15:18:04.798313+00'),
	('AND', 'AD', '020', 'Andorra', 'Andorra', 'Europa e Ásia Central', false, '020', '2026-11-09 15:18:04.798313+00'),
	('ARE', 'AE', '784', 'Emirados Árabes Unidos', 'United Arab Emirates', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '784', '2026-11-09 15:18:04.798313+00'),
	('ARG', 'AR', '032', 'Argentina', 'Argentina', 'América Latina e Caribe', true, '032', '2026-11-09 15:18:04.798313+00'),
	('ARM', 'AM', '051', 'Armênia', 'Armenia', 'Europa e Ásia Central', false, '051', '2026-11-09 15:18:04.798313+00'),
	('ASM', 'AS', '016', 'Samoa Americana', 'American Samoa', 'Leste Asiático e Pacífico', false, '016', '2026-11-09 15:18:04.798313+00'),
	('ATA', 'AQ', '010', 'Antártida', 'Antarctica', NULL, false, '010', '2026-11-09 15:18:04.798313+00'),
	('BEN', 'BJ', '204', 'Benin', 'Benin', 'África Subsaariana', false, '204', '2026-11-09 15:18:04.798313+00'),
	('MYT', 'YT', '175', 'Maiote', 'Mayotte', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('TTO', 'TT', '780', 'Trinidade e Tobago', 'Trinidad and Tobago', 'América Latina e Caribe', false, '780', '2026-11-09 15:18:04.798313+00'),
	('TUN', 'TN', '788', 'Tunísia', 'Tunisia', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '788', '2026-11-09 15:18:04.798313+00'),
	('TUR', 'TR', '792', 'Turquia', 'Türkiye', 'Europa e Ásia Central', true, '792', '2026-11-09 15:18:04.798313+00'),
	('TUV', 'TV', '798', 'Tuvalu', 'Tuvalu', 'Leste Asiático e Pacífico', false, NULL, '2026-11-09 15:18:04.798313+00'),
	('TWN', 'TW', '158', 'Taiwan', 'Taiwan', NULL, false, '158', '2026-11-09 15:18:04.798313+00'),
	('TZA', 'TZ', '834', 'Tanzânia', 'Tanzania', 'África Subsaariana', false, '834', '2026-11-09 15:18:04.798313+00'),
	('UGA', 'UG', '800', 'Uganda', 'Uganda', 'África Subsaariana', false, '800', '2026-11-09 15:18:04.798313+00'),
	('UKR', 'UA', '804', 'Ucrânia', 'Ukraine', 'Europa e Ásia Central', false, '804', '2026-11-09 15:18:04.798313+00'),
	('UMI', 'UM', '581', 'Ilhas Menores Distantes dos Estados Unidos', 'United States Minor Outlying Islands', NULL, false, NULL, '2026-11-09 15:18:04.798313+00'),
	('URY', 'UY', '858', 'Uruguai', 'Uruguay', 'América Latina e Caribe', true, '858', '2026-11-09 15:18:04.798313+00'),
	('USA', 'US', '840', 'Estados Unidos', 'United States', 'América do Norte', true, '840', '2026-11-09 15:18:04.798313+00'),
	('UZB', 'UZ', '860', 'Uzbequistão', 'Uzbekistan', 'Europa e Ásia Central', false, '860', '2026-11-09 15:18:04.798313+00'),
	('VAT', 'VA', '336', 'Vaticano', 'Holy See (Vatican City State)', NULL, false, '336', '2026-11-09 15:18:04.798313+00'),
	('VCT', 'VC', '670', 'São Vicente e Granadinas', 'Saint Vincent and the Grenadines', 'América Latina e Caribe', false, '670', '2026-11-09 15:18:04.798313+00'),
	('VGB', 'VG', '092', 'Ilhas Virgens Britânicas', 'Virgin Islands, British', 'América Latina e Caribe', false, '092', '2026-11-09 15:18:04.798313+00'),
	('VIR', 'VI', '850', 'Ilhas Virgens dos Estados Unidos', 'Virgin Islands, U.S.', 'América Latina e Caribe', false, '850', '2026-11-09 15:18:04.798313+00'),
	('VNM', 'VN', '704', 'Vietnã', 'Vietnam', 'Leste Asiático e Pacífico', false, '704', '2026-11-09 15:18:04.798313+00'),
	('VUT', 'VU', '548', 'Vanuatu', 'Vanuatu', 'Leste Asiático e Pacífico', false, '548', '2026-11-09 15:18:04.798313+00'),
	('WLF', 'WF', '876', 'Wallis e Futuna', 'Wallis and Futuna', NULL, false, '876', '2026-11-09 15:18:04.798313+00'),
	('WSM', 'WS', '882', 'Samoa', 'Samoa', 'Leste Asiático e Pacífico', false, '882', '2026-11-09 15:18:04.798313+00'),
	('YEM', 'YE', '887', 'Iêmen', 'Yemen', 'Oriente Médio, Norte da África, Afeganistão e Paquistão', false, '887', '2026-11-09 15:18:04.798313+00'),
	('ZAF', 'ZA', '710', 'África do Sul', 'South Africa', 'África Subsaariana', true, '710', '2026-11-09 15:18:04.798313+00'),
	('ZMB', 'ZM', '894', 'Zâmbia', 'Zambia', 'África Subsaariana', false, '894', '2026-11-09 15:18:04.798313+00'),
	('ZWE', 'ZW', '716', 'Zimbábue', 'Zimbabwe', 'África Subsaariana', false, '716', '2026-11-09 15:18:04.798313+00');


--
-- PostgreSQL database dump complete
--

\unrestrict eoULtSp2F0mwXQub6ydRLirRXDhIw3Am8bWlrWj5soQBRRgSjinCsRNTaKBNDfG

COPY public.series FROM stdin WITH CSV;
BRA,balanca_bens_servicos,1960,-8829343.27884779,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1961,-9149902.73913831,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1962,-263069676.369544,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1963,-17161538.9976371,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1964,150139738.736652,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1965,474987147.832509,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1966,225450250.410952,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1967,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1968,-206594912.095925,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1969,24981601.3881669,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1970,-177912553.313845,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1971,-848612874.357427,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1972,-927784676.017155,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1973,-975055646.878116,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1974,-6172123572.14926,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1975,-4907560235.7633,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1976,-3659545985.35254,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1977,-1172207021.18182,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1978,-2387152105.92509,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1979,-4615615400.08842,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1980,-5295341312.05211,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1981,-999146350.182735,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1982,-1872613597.52443,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1983,4906714630.16912,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1984,11753827695.9679,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1985,11487450960.2675,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1986,6601570907.53894,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1987,9608553171.41755,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1988,17141241474.9105,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1989,14323932823.013,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1990,4769166666.66667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1991,2614204545.45455,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1992,8149820788.53047,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1993,5182689343.46997,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1994,1846111836.60205,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1995,-14822816228.5448,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1996,-18498238583.2255,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1997,-23042055321.3753,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1998,-20535451010.1963,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,1999,-11107588703.6622,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2000,-14837154501.7199,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2001,-12279677753.7929,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2002,4296672536.94147,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2003,12399391351.6763,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2004,22844658798.4967,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2005,30323248288.0722,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2006,29982705220.8702,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2007,19039021641.8823,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2008,-3214805206.98649,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2009,-6721885359.21274,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2010,-22994190061.8851,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2011,-20128178014.6088,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2012,-33507264617.8911,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2013,-56911843574.1753,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2014,-65368099306.7432,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2015,-20783887933.0453,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2016,7176956033.44644,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2017,14820192743.6611,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2018,7548801625.69362,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2019,-12071834245.961,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2020,8930824788.04325,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2021,9397892444.40671,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2022,8695119065.37025,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2023,49791689659.1769,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2024,6396477782.71593,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,balanca_bens_servicos,2025,7978888855.87743,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
BRA,desemprego,1991,6.887,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1992,7.086,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1993,6.03,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1994,6.579,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1995,7.092,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1996,8.035,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1997,9.003,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1998,10.15,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,1999,11.125,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2000,10.889,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2001,10.649,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2002,10.641,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2003,11.168,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2004,10.072,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2005,10.551,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2006,9.692,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2007,9.28,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2008,8.268,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2009,9.419,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2010,8.42,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2011,7.578,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2012,7.251,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2013,7.071,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2014,6.755,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2015,8.538,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2016,11.58,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2017,12.792,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2018,12.329,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2019,11.936,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2020,13.697,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2021,13.158,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2022,9.231,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2023,7.947,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2024,6.801,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,desemprego,2025,5.97,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
BRA,divida_publica_pib,2000,62.197623,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2001,67.330659,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2002,76.095054,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2003,71.51364,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2004,68.025064,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2005,66.968516,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2006,64.598819,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2007,63.024659,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2008,61.420078,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2009,64.701584,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2010,62.433202,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2011,60.63371,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2012,61.614255,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2013,59.594682,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2014,61.617149,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2015,71.729677,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2016,77.422191,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2017,82.744953,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2018,84.777046,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2019,87.118481,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2020,96.006839,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2021,88.934272,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2022,83.938835,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2023,84.000518,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2024,87.027887,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,divida_publica_pib,2025,93.329176,fmi-weo,WEO publicado em 2026-10-13,2026-10-13,2026-11-09 15:18:09.190649+00
BRA,inflacao,1981,101.725072957927,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1982,100.543359194849,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1983,135.027682230472,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1984,192.12173313205,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1985,225.989665211895,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1986,147.142826237604,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1987,228.336162575512,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1988,629.114509120897,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1989,1430.7237251472,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1990,2947.73277248299,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1991,432.786661926461,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1992,951.962053052817,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1993,1927.38079016026,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1994,2075.88839757325,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1995,66.0070335542481,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1996,15.7576656002606,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1997,6.92671251629154,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1998,3.19507629280051,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,1999,4.85844749902666,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2000,7.04414105947265,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2001,6.84035902487523,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2002,8.45016437708331,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2003,14.7149197228147,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2004,6.59718509985963,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2005,6.86953720898964,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2006,4.18356812896909,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2007,3.64127299102652,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2008,5.67859390284168,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2009,4.88803479876798,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2010,5.03872690108074,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2011,6.6364496221309,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2012,5.40349914036997,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2013,6.204310666401,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2014,6.32904015516138,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2015,9.02990102416136,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2016,8.73914352329393,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2017,3.44637335032669,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2018,3.66485028376728,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2019,3.73297621216893,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2020,3.21176803803376,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2021,8.30165975585673,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2022,9.28010608956872,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2023,4.59356282283203,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2024,4.36746407652336,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,inflacao,2025,5.01675279604836,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
BRA,pib,1960,17030465539.3906,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1961,17275940449.3837,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1962,19231747851.5332,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1963,23287712878.2002,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1964,20963733694.9749,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1965,22465522884.0988,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1966,28283323733.1114,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1967,31086389194.961,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1968,33930457425.2613,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1969,37171640818.5863,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1970,42327664793.6934,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1971,48869830901.7878,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1972,58434858374.8696,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1973,83592275862.9982,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1974,109794519727.538,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1975,129203555238.827,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1976,153168949208.207,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1977,176344101401.941,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1978,200278646123.581,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1979,221338204480.222,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1980,237393489892.637,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1981,258015174748.648,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1982,271314113768.417,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1983,189656506321.431,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1984,188339974086.58,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1985,210879844638.877,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1986,256480852471.129,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1987,283056836893.838,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1988,307881930752.268,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1989,412990820287.42,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1990,384959818181.817,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1991,342534090909.091,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1992,328191909882.232,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1993,368292034380.96,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1994,525369467295.737,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1995,769333050986.905,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1996,850426432991.742,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1997,883206179730.462,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1998,863710759256.435,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,1999,599642024319.531,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2000,655448231983.527,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2001,559983634798.981,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2002,509795273806.715,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2003,558233745651.874,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2004,669289424806.307,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2005,891633839894.183,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2006,1107626541434.92,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2007,1397114486368.67,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2008,1695855083497.52,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2009,1666996438581.43,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2010,2208837745100.55,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2011,2616156223917.69,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2012,2465227802806.76,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2013,2472819535557.21,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2014,2456043727198.85,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2015,1802212206814.5,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2016,1795693482853.01,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2017,2063514977365.65,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2018,1916933898010.99,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2019,1873288205059.69,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2020,1476107231310.49,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2021,1670647398904.9,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2022,1951923942083.32,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2023,2191131765684.63,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2024,2185821610689.31,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib,2025,2279920092492.13,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
BRA,pib_crescimento,1961,8.60000000000014,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1962,6.59999999999992,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1963,0.600000000000065,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1964,3.39999999999985,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1965,2.40000000000001,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1966,6.7000000000001,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1967,4.2,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1968,9.79999999999998,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1969,9.49999999999993,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1970,10.4,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1971,11.3429219931908,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1972,11.9403481162508,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1973,13.9687217796782,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1974,8.15393868457201,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1975,5.16664908406321,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1976,10.2571295347867,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1977,4.93432806978961,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1978,4.96989768924738,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1979,6.7595601220408,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1980,9.19999999999976,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1981,-4.24999999999956,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1982,0.829999999999529,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1983,-2.92999999999996,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1984,5.39999999999988,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1985,7.85000000000042,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1986,7.48999999999982,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1987,3.52999999999983,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1988,-0.059999999999917,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1989,3.16000000000032,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1990,-4.35000000000022,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1991,1.03218958549303,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1992,-0.54407204977727,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1993,4.9246900037071,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1994,5.85287036219013,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1995,4.22379363350413,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1996,2.20886405039022,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1997,3.39484598630671,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1998,0.338097901207306,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,1999,0.467937566477133,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2000,4.38794944745618,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2001,1.38989640095637,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2002,3.05346185909312,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2003,1.14082899824888,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2004,5.75996463670954,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2005,3.20213206130431,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2006,3.96198871122617,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2007,6.06987060678338,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2008,5.09419544658736,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2009,-0.125812002161169,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2010,7.52822581815364,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2011,3.97442307944702,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2012,1.92117598576537,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2013,3.00482266944432,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2014,0.503955740242247,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2015,-3.54576339269425,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2016,-3.27591690782192,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2017,1.32286905404399,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2018,1.783666761634,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2019,1.22077782360842,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2020,-3.2767587964736,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2021,4.76260437908608,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2022,3.01669435393015,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2023,3.24165532906981,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2024,3.41931516501906,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_crescimento,2025,2.2857464902475,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
BRA,pib_per_capita,1960,235.266009502589,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1961,231.564063269854,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1962,250.200572910273,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1963,294.169619376733,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1964,257.259726897671,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1965,268.028760553723,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1966,328.343791519407,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1967,351.472600370379,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1968,373.925432639683,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1969,399.49841913391,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1970,443.799484982738,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1971,500.001988983361,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1972,583.492034946156,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1973,814.731780553415,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1974,1044.76980947499,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1975,1200.55823714607,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1976,1389.74952306555,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1977,1562.29143045708,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1978,1732.50012204556,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1979,1869.7133759549,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1980,1958.57159232662,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1981,2079.70908377484,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1982,2137.6250359394,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1983,1461.25582714178,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1984,1419.73154606978,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1985,1556.1297180511,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1986,1854.03775211919,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1987,2006.00226235757,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1988,2140.65027561164,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1989,2818.99277980122,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1990,2581.14187449078,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1991,2257.6092968885,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1992,2127.31642731638,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1993,2348.88247685352,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1994,3298.71250747787,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1995,4756.74840785403,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1996,5179.13052002464,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1997,5299.39630404412,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1998,5105.89099544117,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,1999,3493.57162513699,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2000,3766.54811466032,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2001,3176.28935747524,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2002,2855.94018885769,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2003,3090.6070097455,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2004,3663.823188064,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2005,4827.78173074714,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2006,5934.14470924968,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2007,7409.69130673473,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2008,8908.33176538648,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2009,8678.6592244676,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2010,11403.2821278747,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2011,13396.6243562986,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2012,12521.7213519966,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2013,12458.8912138813,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2014,12274.9939689363,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2015,8936.19661712113,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2016,8836.28652735657,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2017,10080.5092819305,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2018,9300.66164923219,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2019,9029.83326681073,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2020,7074.19378337644,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2021,7972.5366498646,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2022,9281.33334441234,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2023,10377.5892792557,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2024,10310.5486973693,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,pib_per_capita,2025,10713.2856869511,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
BRA,populacao,1960,72388126,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1961,74605447,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1962,76865323,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1963,79164235,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1964,81488595,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1965,83817583,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1966,86139359,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1967,88446124,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1968,90741240,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1969,93045777,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1970,95375651,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1971,97739273,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1972,100146797,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1973,102600976,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1974,105089675,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1975,107619565,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1976,110213349,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1977,112875292,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1978,115600942,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1979,118380821,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1980,121207461,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1981,124063109,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1982,126923155,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1983,129790077,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1984,132658864,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1985,135515595,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1986,138336370,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1987,141104944,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1988,143826357,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1989,146502972,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1990,149143223,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1991,151724256,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1992,154275079,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1993,156794577,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1994,159265006,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1995,161735073,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1996,164202549,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1997,166661659,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1998,169159655,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,1999,171641543,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2000,174018282,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2001,176301203,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2002,178503484,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2003,180622688,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2004,182675143,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2005,184688101,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2006,186653106,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2007,188552320,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2008,190367302,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2009,192079951,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2010,193701929,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2011,195284734,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2012,196876111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2013,198478299,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2014,200085127,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2015,201675532,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2016,203218114,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2017,204703445,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2018,206107261,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2019,207455459,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2020,208660842,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2021,209550294,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2022,210306415,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2023,211140729,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2024,211998573,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
BRA,populacao,2025,212812405,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,balanca_bens_servicos,1960,-877800877.800878,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1961,-648900648.900649,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1962,-785400785.400785,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1963,-787500787.500787,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1964,-1106701106.70111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1965,-1134001134.00113,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1966,-1152811397.49988,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1967,-958666666.666667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1968,-480000000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1969,-185333333.333333,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1970,-60000000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1971,-225759297.050052,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1972,227671475.752276,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1973,-440047977.947746,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1974,-1183618321.20793,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1975,-984594448.204727,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1976,587355938.369916,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1977,143648829.764224,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1978,-375331507.288682,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1979,-2171813476.63505,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1980,-5786386673.29392,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1981,-5098906809.1628,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1982,-4334108792.25847,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1983,-4398713512.06048,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1984,-3060529242.73438,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1985,-5559179686.36682,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1986,-4548547295.97622,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1987,-3838531827.11956,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1988,-4211604784.44382,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1989,-3362657410.3865,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1990,-4492297406.46851,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1991,2039268.14744724,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1992,-2153620947.4925,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1993,47187344.1502455,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1994,-988286716.27677,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1995,-4249570649.91894,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1996,-4554261385.02672,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1997,-5148241778.54987,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1998,-7005099303.37479,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,1999,-8770221354.34094,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2000,-4245772553.85266,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2001,-4254860905.48757,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2002,-5045863334.09825,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2003,-4233294134.79524,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2004,-12662376776.6838,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2005,-22898356562.5501,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2006,-29981104763.5886,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2007,-49726426539.3318,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2008,-62024910978.4082,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2009,-73425843079.1054,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2010,-74620856172.5351,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2011,-119283327194.816,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2012,-122906076681.132,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2013,-55375035765.8071,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2014,-60893612907.7324,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2015,-48309654578.3717,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2016,-40526477691.9238,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2017,-83759204290.0468,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2018,-101665620603.104,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2019,-73069992885.3108,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2020,-10516218299.5447,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2021,-83133636377.4612,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2022,-85070227554.9395,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2023,-56481801795.2902,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2024,-67270704657.5415,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,balanca_bens_servicos,2025,-68919379154.6131,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
IND,desemprego,1991,7.641,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1992,7.649,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1993,7.662,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1994,7.593,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1995,7.57,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1996,7.537,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1997,7.574,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1998,7.596,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,1999,7.583,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2000,7.589,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2001,7.611,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2002,7.681,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2003,7.633,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2004,7.598,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2005,7.551,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2006,7.553,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2007,7.562,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2008,7.629,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2009,7.636,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2010,7.631,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2011,7.609,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2012,7.645,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2013,7.678,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2014,7.656,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2015,7.629,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2016,7.611,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2017,7.626,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2018,7.652,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2019,6.51,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2020,7.859,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2021,6.38,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2022,4.822,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2023,4.172,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2024,4.173,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,desemprego,2025,4.219,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
IND,inflacao,1960,1.7798778467739,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1961,1.69521293914432,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1962,3.63221497106987,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1963,2.94616135685225,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1964,13.3552611508153,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1965,9.47475859170695,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1966,10.801848348934,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1967,13.0622024777969,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1968,3.23741242627507,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1969,-0.584136610466281,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1970,5.09226161997544,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1971,3.07993868406546,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1972,6.44209746158234,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1973,16.9408159791736,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1974,28.5987340775089,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1975,5.74843029767442,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1976,-7.6339476339288,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1977,8.30747009171166,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1978,2.52304875695178,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1979,6.27568336762337,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1980,11.3460734795095,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1981,13.1125468976419,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1982,7.89074279377487,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1983,11.8680812986733,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1984,8.31890711860072,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1985,5.55642423236554,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1986,8.72972072702581,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1987,8.80112581251833,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1988,9.38347186185335,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1989,7.07428002942296,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1990,8.97123250273255,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1991,13.8702461773683,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1992,11.7878170418133,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1993,6.32689048779867,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1994,10.2479355556118,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1995,10.2248861637545,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1996,8.97715233826452,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1997,7.16425211462721,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1998,13.2308389767977,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,1999,4.66982038037589,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2000,4.0094359104519,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2001,3.77929312235637,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2002,4.29715203929561,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2003,3.80585899528852,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2004,3.76725173477517,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2005,4.24634362031923,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2006,5.79652337561633,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2007,6.37288135593231,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2008,8.34926704907574,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2009,10.8823529411764,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2010,11.9893899204244,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2011,8.9117933648336,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2012,9.47899691419792,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2013,10.0178784746104,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2014,6.66565671867899,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2015,4.90697344127249,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2016,4.94821634062134,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2017,3.32817337461304,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2018,3.93882646691642,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2019,3.72950573539123,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2020,6.62343677628529,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2021,5.13140747176363,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2022,6.69903414079857,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2023,5.64914318907925,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2024,4.9530355097366,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,inflacao,2025,2.39884954182294,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
IND,pib,1960,37029883876.1839,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1961,39232435784.0358,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1962,42161481858.0819,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1963,48421923459.1235,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1964,56480289940.9899,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1965,59556105229.0052,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1966,45581230504.071,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1967,50134942204,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1968,53085455870.6667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1969,58447995017.3333,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1970,62422483054.6667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1971,67351404351.833,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1972,71464700666.9869,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1973,85517673172.5513,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1974,99526597933.6331,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1975,98473832017.3242,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1976,102716451979.68,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1977,121486641441.309,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1978,137302319828.995,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1979,152995442497.709,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1980,186328579302.068,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1981,193491368445.573,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1982,200715624830.902,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1983,218262146413.158,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1984,212157645177.652,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1985,232511554840.372,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1986,248985994040.59,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1987,279033584092.223,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1988,296589670895.932,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1989,296042052944.66,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1990,320979026420.035,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1991,270105341879.226,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1992,288208070278.013,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1993,279295648982.529,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1994,327274843459.429,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1995,360281909643.489,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1996,392896866204.516,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1997,415867563592.829,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1998,421351317224.941,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,1999,458821052615.79,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2000,468395521654.458,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2001,485440139204.171,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2002,514939140318.756,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2003,607700687237.318,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2004,709152728830.775,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2005,820383763511.445,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2006,940259888787.721,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2007,1216736438834.96,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2008,1198895139005.92,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2009,1341888016994.9,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2010,1675615519484.96,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2011,1823051829894.55,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2012,1827637590410.41,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2013,1856721507621.58,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2014,2039126479154.52,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2015,2103588360044.94,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2016,2294796885663.16,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2017,2651474262755.45,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2018,2702929641648.74,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2019,2835606256558.19,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2020,2674851578587.27,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2021,3167270623260.47,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2022,3249938492013.47,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2023,3500906030644.76,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2024,3760813470500.86,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib,2025,3956067115771.63,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
IND,pib_crescimento,1961,3.72274253269822,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1962,2.93112773665958,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1963,5.99435326095178,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1964,7.45295012232975,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1965,-2.63577010985361,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1966,-0.0553287698318314,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1967,7.82596303033105,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1968,3.38792917600242,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1969,6.53970029628042,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1970,5.15722973608261,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1971,1.64293038388766,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1972,-0.553301312377712,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1973,3.29552113522354,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1974,1.18533626034039,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1975,9.14991201480592,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1976,1.66310363661279,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1977,7.25476458583569,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1978,5.71253208900188,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1979,-5.2381827027895,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1980,6.7358215279985,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1981,6.00620362381767,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1982,3.47573324031237,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1983,7.28889290124586,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1984,3.8207378559735,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1985,5.25429922330889,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1986,4.77656417048946,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1987,3.96535563390576,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1988,9.62778291984834,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1989,5.94734332826503,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1990,5.53345456306495,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1991,1.05683143296179,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1992,5.48239602167003,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1993,4.7507762195799,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1994,6.65892406747307,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1995,7.57449184027195,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1996,7.54952224888829,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1997,4.04982084902483,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1998,6.18441582080355,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,1999,8.84575556114116,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2000,3.84099115686554,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2001,4.82396626397303,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2002,3.80397532120038,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2003,7.86038147545045,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2004,7.92293661307978,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2005,7.92343062131789,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2006,8.06073257305057,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2007,7.66081506510766,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2008,3.08669805950082,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2009,7.8618888330338,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2010,8.49758470165625,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2011,5.24131620024293,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2012,5.45638755164772,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2013,6.38610640091713,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2014,7.41022760516977,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2015,7.99625378567987,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2016,8.25630550176662,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2017,6.79538341902422,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2018,6.45385134495295,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2019,3.87143694070524,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2020,-5.77772470687303,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2021,9.68959249191741,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2022,7.6093649776932,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2023,7.210224629335,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2024,7.09927893176518,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_crescimento,2025,7.56666179284244,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
IND,pib_per_capita,1960,84.9328084793106,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1961,87.8538613470205,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1962,92.1999583629516,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1963,103.435021262932,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1964,117.856430772855,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1965,121.50831902883,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1966,91.0276950517841,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1967,97.9951481214155,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1968,101.556802521195,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1969,109.477664384288,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1970,114.35532002008,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1971,120.680595539912,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1972,125.270705961882,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1973,146.568492582405,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1974,166.699661755332,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1975,161.086694022079,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1976,164.119999587322,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1977,189.585568552477,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1978,209.389063573463,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1979,227.958179873426,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1980,271.080945953678,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1981,274.964330768528,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1982,278.65038258267,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1983,295.999773299382,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1984,281.049867840717,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1985,300.928258576378,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1986,314.897116402542,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1987,344.941028293075,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1988,358.484539641693,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1989,349.915155021864,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1990,371.085936203765,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1991,305.574055928592,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1992,319.182472626315,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1993,302.884806246174,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1994,347.73421473994,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1995,375.17600537305,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1996,401.046754673579,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1997,416.228116203753,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1998,413.630864056851,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,1999,441.927991436397,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2000,442.750218937263,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2001,450.357900514128,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2002,469.149928973927,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2003,544.143133545002,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2004,624.258826510066,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2005,710.488080408949,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2006,801.668353659022,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2007,1021.88707706826,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2008,992.519584923828,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2009,1094.94974598436,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2010,1347.51939071367,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2011,1445.46127486037,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2012,1429.32199520032,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2013,1432.84397512195,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2014,1553.88396075118,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2015,1583.99815907985,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2016,1707.50892912243,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2017,1950.10468280866,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2018,1966.25455171679,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2019,2041.42863698585,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2020,1907.04251637669,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2021,2239.61384367482,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2022,2279.98145719369,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2023,2434.44826340989,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2024,2591.9916607122,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,pib_per_capita,2025,2702.47987141553,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
IND,populacao,1960,435990338,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1961,446564729,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1962,457283090,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1963,468138575,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1964,479229598,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1965,490140146,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1966,500740247,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1967,511606372,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1968,522716889,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1969,533880544,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1970,545864268,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1971,558096387,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1972,570482142,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1973,583465598,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1974,597041391,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1975,611309535,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1976,625861883,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1977,640801103,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1978,655728229,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1979,671155747,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1980,687354025,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1981,703696250,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1982,720313473,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1983,737372681,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1984,754875449,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1985,772647793,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1986,790689978,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1987,808931270,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1988,827342990,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1989,846039529,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1990,864972221,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1991,883927600,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1992,902957070,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1993,922118387,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1994,941163767,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1995,960301044,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1996,979678458,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1997,999133762,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1998,1018665080,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,1999,1038225823,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2000,1057922733,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2001,1077898575,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2002,1097600380,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2003,1116803006,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2004,1135991513,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2005,1154676322,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2006,1172878890,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2007,1190676021,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2008,1207930964,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2009,1225524753,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2010,1243481564,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2011,1261224954,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2012,1278674502,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2013,1295829511,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2014,1312277191,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2015,1328024498,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2016,1343944296,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2017,1359657400,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2018,1374659064,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2019,1389030312,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2020,1402617695,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2021,1414203896,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2022,1425423212,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2023,1438069596,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2024,1450935791,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
IND,populacao,2025,1463865525,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,balanca_bens_servicos,1960,941520089.844465,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1961,1191969750.09462,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1962,1390138322.63612,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1963,1619952234.53675,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1964,998252873.563219,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1965,838644444.444444,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1966,924688888.888889,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1967,903177777.777778,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1968,580600000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1969,473111111.111111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1970,516111111.111111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1971,813750000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1972,461863636.363636,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1973,1620302325.5814,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1974,6368744186.04651,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1975,2160418604.65116,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1976,270069767.44186,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1977,-2880558139.53488,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1978,-5176000000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1979,720139534.883721,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1980,4658418604.65116,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1981,3713232558.13953,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1982,-2002883720.93023,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1983,6526279069.76744,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1984,4494997624.70308,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1985,3506506666.66667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1986,-251764948.453608,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1987,-877193103.448276,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1988,-3892310344.82759,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1989,5491872207.54263,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1990,9061996090.27901,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1991,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1992,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1993,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1994,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1995,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1996,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1997,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1998,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,1999,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2000,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2001,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2002,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2003,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2004,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2005,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2006,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2007,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2008,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2009,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2010,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2011,0,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2012,31381274616.5432,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2013,-5403332873.43583,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2014,48997528951.9946,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2015,26467912240.7468,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2016,23722233638.7741,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2017,27874138562.2744,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2018,31066235864.2973,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2019,26476840423.9872,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2020,-34132875.1711994,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2021,834346180.125041,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2022,4272755669.51985,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2023,8229411760.72527,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2024,8720159719.81503,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,balanca_bens_servicos,2025,4778560653.31225,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.88734+00
VEN,desemprego,1991,9.45,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1992,7.69,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1993,6.6,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1994,8.56,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1995,10.24,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1996,11.77,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1997,11.16,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1998,11.15,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,1999,14.53,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2000,13.99,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2001,13.04,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2002,16.17,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2003,16.78,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2004,15.07,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2005,10.663,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2006,8.606,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2007,7.279,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2008,6.245,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2009,6.097,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2010,7.112,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2011,6.902,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2012,6.601,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2013,7.54,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2014,6.821,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2015,6.139,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2016,5.319,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2017,5.045,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2018,5.468,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2019,5.89,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2020,7.53,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2021,7.027,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2022,5.646,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2023,5.407,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2024,5.321,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,desemprego,2025,5.307,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.556373+00
VEN,inflacao,2009,27.080941446613,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2010,28.1874647092039,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2011,26.0902123160959,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2012,21.0689956331875,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2013,40.6394275161589,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2014,62.1686499794828,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2015,121.738085297503,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,inflacao,2016,254.948534781816,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:07.004863+00
VEN,pib,1960,7663938303.07171,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1961,8067267030.61862,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1962,8814309884.21165,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1963,9608717288.17057,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1964,8192413793.10345,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1965,8427777777.77778,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1966,8781333333.33333,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1967,9250000000,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1968,10034444444.4444,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1969,10285111111.1111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1970,11561111111.1111,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1971,12986590909.0909,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1972,13977727272.7273,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1973,17035581395.3488,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1974,26100930232.5581,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1975,27464651162.7907,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1976,31419534883.7209,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1977,36210697674.4186,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1978,39316279069.7674,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1979,48310930232.5581,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1980,59116511627.907,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1981,66327441860.4651,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1982,67736744186.0465,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1983,67556279069.7674,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1984,59867743467.9335,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1985,61965466666.6667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1986,60516123711.3402,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1987,48029034482.7586,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1988,60226413793.1035,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1989,43536709104.0115,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1990,48606952194.7752,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1991,53453444786.6256,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1992,60416519620.0849,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1993,60037460783.1941,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1994,58418666666.6667,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1995,77389487770.0883,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1996,70543211119.099,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1997,85837678559.8324,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1998,91336763255.0597,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,1999,97972842461.5131,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2000,117146466002.661,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2001,122911036746.729,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2002,92893587733.6549,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2003,83620628582.1082,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2004,112451400424.964,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2005,145513489651.872,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2006,183477522123.894,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2007,230364012575.687,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2008,315953388510.678,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2009,329787628928.472,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2010,393192354510.653,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2011,316482190800.364,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2012,371846610182.327,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2013,258512396297.714,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2014,214838755021.964,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2015,125249941853.534,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2016,112948035494.959,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2017,115892475742.789,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2018,101987075928.918,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2019,73014157107.594,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2020,42837965906.8675,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2021,56615026262.6535,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2022,89013251020.9831,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2023,102377501185.925,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2024,120566112397.063,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib,2025,99661244155.6306,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:05.678621+00
VEN,pib_crescimento,1961,3.19251943889398,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1962,8.53293376290674,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1963,3.90095116381792,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1964,11.1293452932632,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1965,4.16286666476357,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1966,1.51025011101906,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1967,2.83386903098911,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1968,7.33723265821649,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1969,0.706036796155843,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1970,7.71191438124403,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1971,1.47929120998975,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1972,1.28280503619405,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1973,7.10995789495574,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1974,2.0693332016931,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1975,2.89625778007141,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1976,7.72773984679841,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1977,6.27078351298832,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1978,2.34689637191228,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1979,0.764355145425611,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1980,-4.42132236441761,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1981,-1.26182965299685,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1982,2.55591054313101,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1983,-9.65732087227414,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1984,5.17241379310344,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1985,0.655737704918025,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1986,6.18892508143323,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1987,4.9079754601227,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1988,6.43274853801171,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1989,-14.010989010989,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1990,6.70926517571885,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1991,9.5808383233533,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1992,6.01092896174865,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1993,0.257731958762889,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1994,-2.31362467866325,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1995,3.94736842105263,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1996,-0.25316455696202,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1997,6.34517766497463,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1998,0.477326968973756,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,1999,-5.93824228028504,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2000,3.53535353535352,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2001,3.41463414634147,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2002,-8.72641509433961,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2003,-7.75193798449614,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2004,18.2072829131653,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2005,10.1895734597156,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2006,9.89247311827957,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2007,8.80626223091976,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2008,5.21582733812949,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2009,-3.07692307692308,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2010,-1.5873015873016,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2011,4.12186379928315,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2012,5.67986230636832,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2013,1.30293159609121,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2014,-3.85852090032154,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2015,-6.18729096989966,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2016,-17.1122994652406,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2017,-15.6989247311828,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2018,-19.6428571428571,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2019,-27.6190476190476,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2020,-29.8245614035088,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2021,0.625000000000014,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2022,8.07453416149069,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2023,4.02298850574712,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2024,5.52486187845305,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_crescimento,2025,1.57068062827224,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.109602+00
VEN,pib_per_capita,1960,939.197766577539,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1961,954.038330638213,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1962,1006.55940812318,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1963,1060.09433210388,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1964,873.604754880876,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1965,869.041067890496,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1966,875.956231715029,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1967,892.985315556393,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1968,938.015078662499,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1969,931.598755748143,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1970,1015.21990755986,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1971,1106.08824294225,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1972,1155.26236263344,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1973,1366.83361997071,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1974,2033.51900797712,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1975,2078.1534203511,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1976,2309.19293494983,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1977,2585.22051087846,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1978,2727.13746585327,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1979,3256.64908738452,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1980,3874.40470623155,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1981,4228.0988152685,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1982,4201.54283466342,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1983,4078.94233103427,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1984,3519.80146489308,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1985,3548.70434276284,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1986,3376.34960597843,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1987,2610.98837126004,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1988,3191.47633742656,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1989,2250.08459665588,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1990,2451.5523114567,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1991,2632.53969814106,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1992,2907.30334439434,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1993,2824.69144366441,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1994,2688.98325145295,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1995,3486.98350635919,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1996,3112.825848106,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1997,3710.82688355096,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1998,3869.98258848894,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,1999,4070.90619189484,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2000,4776.2816763938,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2001,4920.39313600453,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2002,3652.09896501865,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2003,3229.50557082079,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2004,4269.08970872392,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2005,5432.4854184654,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2006,6739.38065342218,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2007,8331.62096991844,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2008,11262.4514256759,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2009,11596.6021921731,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2010,13646.3046622664,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2011,10843.9229703167,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2012,12582.0125686037,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2013,8642.37380007027,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2014,7101.15006382986,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2015,4096.61989137473,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2016,3671.23004093383,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2017,3791.63262049576,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2018,3421.51341607593,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2019,2523.11527549578,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2020,1506.04169391285,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2021,2004.93572921136,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2022,3155.04190923584,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2023,3617.47038396528,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2024,4244.45723136019,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,pib_per_capita,2025,3494.8138870244,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:06.498652+00
VEN,populacao,1960,8160090,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1961,8455915,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1962,8756870,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1963,9064021,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1964,9377712,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1965,9697790,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1966,10024854,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1967,10358513,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1968,10697530,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1969,11040280,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1970,11387790,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1971,11741008,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1972,12099180,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1973,12463537,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1974,12835351,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1975,13215892,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1976,13606284,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1977,14006812,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1978,14416684,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1979,14834552,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1980,15258218,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1981,15687297,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1982,16121874,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1983,16562205,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1984,17008841,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1985,17461434,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1986,17923536,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1987,18394963,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1988,18871020,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1989,19348921,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1990,19827010,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1991,20304896,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1992,20780948,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1993,21254520,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1994,21725188,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1995,22193821,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1996,22662113,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1997,23131685,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1998,23601337,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,1999,24066593,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2000,24526708,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2001,24979922,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2002,25435671,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2003,25892703,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2004,26340838,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2005,26785804,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2006,27224686,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2007,27649363,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2008,28053696,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2009,28438298,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2010,28813101,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2011,29185212,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2012,29553826,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2013,29912198,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2014,30254079,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2015,30573972,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2016,30765720,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2017,30565323,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2018,29807592,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2019,28938098,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2020,28444077,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2021,28237826,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2022,28213017,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2023,28300854,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2024,28405543,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
VEN,populacao,2025,28516896,bm-wdi,"WDI, atualizado em 2026-10-08",2026-10-08,2026-11-09 15:18:08.283538+00
\.
